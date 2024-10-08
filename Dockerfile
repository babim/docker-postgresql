FROM babim/debianbase:12
ENV OSDEB bookworm

# Download option
## ubuntu/debian
RUN apt-get update && \
    apt-get install -y curl bash gnupg && curl https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh -o /option.sh && \
    chmod 755 /option.sh

ENV PG_APP_HOME="/etc/docker-postgresql"\
    PG_VERSION=15 \
    PG_USER=postgres \
    PG_HOME=/var/lib/postgresql \
    PG_RUNDIR=/run/postgresql \
    PG_LOGDIR=/var/log/postgresql \
    PG_CERTDIR=/etc/postgresql/certs

ENV PG_BINDIR=/usr/lib/postgresql/${PG_VERSION}/bin \
    PG_DATADIR=${PG_HOME}/${PG_VERSION}/main

# install
RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20Postgresql%20install/postgresql_install.sh | bash

EXPOSE 5432/tcp
VOLUME ["${PG_HOME}", "${PG_RUNDIR}"]
WORKDIR ${PG_HOME}
ENTRYPOINT ["/entrypoint.sh"]
