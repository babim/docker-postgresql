FROM babim/alpinebase:3.8

ENV LANG en_US.utf8
ENV PG_MAJOR 10
ENV PG_VERSION 10.5

ENV PGDATA /var/lib/postgresql/data

VOLUME /var/lib/postgresql/data

ENTRYPOINT ["/alpine_start.sh"]

EXPOSE 5432
CMD ["postgres"]