FROM babim/alpinebase:3.8

ENV LANG en_US.utf8
ENV PG_MAJOR 9.4
ENV PG_VERSION 9.4.19

# option
RUN apk add --no-cache wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

# install
RUN wget --no-check-certificate -O - https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20Postgresql%20install/postgresql_install.sh | bash

ENV PGDATA /var/lib/postgresql/data

VOLUME /var/lib/postgresql/data

ENTRYPOINT ["/alpine_start.sh"]

EXPOSE 5432
CMD ["postgres"]