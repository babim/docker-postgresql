FROM babim/alpinebase:3.8

ENV LANG en_US.utf8
ENV PG_MAJOR 9.6
ENV PG_VERSION 9.6.10

ENV PGDATA /var/lib/postgresql/data

VOLUME /var/lib/postgresql/data

ENTRYPOINT ["/alpine_start.sh"]

EXPOSE 5432
CMD ["postgres"]