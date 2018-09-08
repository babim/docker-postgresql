FROM babim/alpinebase:3.8

ENV LANG en_US.utf8
ENV PG_MAJOR 9.3
ENV PG_VERSION 9.3.24

ENV PGDATA /var/lib/postgresql/data

VOLUME /var/lib/postgresql/data

ENTRYPOINT ["/alpine_start.sh"]

EXPOSE 5432
CMD ["postgres"]