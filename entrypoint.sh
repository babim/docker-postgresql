#!/bin/bash

set_listen_addresses() {
	sedEscapedValue="$(echo "$1" | sed 's/[\/&]/\\&/g')"
	sed -ri "s/^#?(listen_addresses\s*=\s*)\S+/\1'$sedEscapedValue'/" "$PGDATA/postgresql.conf"
}

if [ "$1" = 'postgres' ]; then
    mkdir -p "$PGDATA"
    chmod 0700 "$PGDATA"
    chown -R postgres "$PGDATA"

    mkdir -p /run/postgresql
    chmod g+s /run/postgresql
    chown -R postgres /run/postgresql

    if [ -z "$(ls -A "$PGDATA")" ]; then
        gosu postgres initdb

        if [ "$DB_PASS" ]; then
            pass="PASSWORD '$DB_PASS'"
            authMethod=md5
        else
            cat >&2 <<-EOWARN
                ****************************************************
                WARNING: No password has been set for the database.
                         This will allow anyone with access to the
                         Postgres port to access your database. In
                         Docker's default configuration, this is
                         effectively any other container on the same
                         system.
                         Use "-e DB_PASS=password" to set
                         it in "docker run".
                ****************************************************
EOWARN
            pass=
            authMethod=trust
        fi

        { echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA/pg_hba.conf"

        gosu postgres pg_ctl -D "$PGDATA" \
            -o "-c listen_addresses=''" \
            -w start
        : ${DB_USER:=postgres}
        : ${DB_NAME:=$DB_USER}
        export DB_USER DB_NAME

        if [ "$DB_NAME" != 'postgres' ]; then
            psql --username postgres <<-EOSQL
                CREATE DATABASE "$DB_NAME" ;
EOSQL
            echo
        fi

        if [ "$DB_USER" == 'postgres' ]; then
            op='ALTER'
        else
            op='CREATE'
        fi

        psql --username postgres <<-EOSQL
            $op USER "$DB_USER" WITH SUPERUSER $pass ;
EOSQL
        echo

        echo
        for f in /docker-entrypoint-initdb.d/*; do
            case "$f" in
                *.sh)  echo "$0: running $f"; . "$f" ;;
                *.sql) echo "$0: running $f"; psql --username "$DB_USER" --dbname "$DB_NAME" < "$f" && echo ;;
                *)     echo "$0: ignoring $f" ;;
            esac
        done

        gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop
        set_listen_addresses '*'

        echo
        echo 'PostgreSQL init process complete; ready for start up.'
        echo
    fi

    exec gosu postgres "$@"
fi

# option with entrypoint
if [ -f "/option.sh" ]; then /option.sh; fi

exec "$@"
