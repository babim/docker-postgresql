FROM babim/alpinebase

ENV PGDATA /var/lib/postgresql
ENV LANG en_US.utf8

ENV GOSU_VERSION 1.10
RUN set -x && \
    apk add --no-cache postgresql postgresql-client postgresql-contrib wget && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" --no-check-certificate && \
    chmod +x /usr/local/bin/gosu && \
    mkdir -p /docker-entrypoint-initdb.d && apk del wget

VOLUME /var/lib/postgresql

ENV DB_NAME ''
ENV DB_USER ''
ENV DB_PASS ''

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
