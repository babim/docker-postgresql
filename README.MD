# Alpine Version
volume:
var/lib/postgresql/data

##start a postgres instance
```
$ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d babim/postgresql:10.alpine
```
This image includes EXPOSE 5432 (the postgres port), so standard container linking will make it automatically available to the linked containers. The default postgres user and database are created in the entrypoint with initdb.

    The postgres database is a default database meant for use by users, utilities and third party applications.
    postgresql.org/docs

connect to it from an application
```
$ docker run --name some-app --link some-postgres:postgres -d application-that-uses-postgres
```
... or via psql

$ docker run -it --link some-postgres:postgres --rm babim/postgresql:10.alpine sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'

## Environment Variables

The PostgreSQL image uses several environment variables which are easy to miss. While none of the variables are required, they may significantly aid you in using the image.

### DB_PASS
This environment variable is recommended for you to use the PostgreSQL image. This environment variable sets the superuser password for PostgreSQL. The default superuser is defined by the POSTGRES_USER environment variable. In the above example, it is being set to "mysecretpassword".

### DB_USER
This optional environment variable is used in conjunction with POSTGRES_PASSWORD to set a user and its password. This variable will create the specified user with superuser power and a database with the same name. If it is not specified, then the default user of postgres will be used.

### PGDATA
This optional environment variable can be used to define another location - like a subdirectory - for the database files. The default is /var/lib/postgresql/, but if the data volume you're using is a fs mountpoint (like with GCE persistent disks), Postgres initdb recommends a subdirectory (for example /var/lib/postgresql/data/pgdata ) be created to contain the data.

### POSTGRES_DB
This optional environment variable can be used to define a different name for the default database that is created when the image is first started. If it is not specified, then the value of POSTGRES_USER will be used.

### LANG
This optional environment variable can be used to define a different locale for created cluster. The default is en_US.UTF-8.
