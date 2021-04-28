FROM alpine
#:3.13
ARG PGBVERSION=1.15.0
ARG CONFDVERSION=0.16.0

COPY conf.d/* /etc/confd/conf.d/
COPY templates/* /etc/confd/templates/
#https://github.com/gmr/alpine-pgbouncer/blob/master/Dockerfile
RUN \
  apk update \
  && apk upgrade --available \
  && apk add curl postgresql-client \
  && addgroup -g 70 -S postgres \
  && adduser -S postgres -G postgres \
  && curl -sL https://github.com/kelseyhightower/confd/releases/download/v${CONFDVERSION}/confd-${CONFDVERSION}-linux-amd64 > /usr/local/bin/confd \
  && chmod +x /usr/local/bin/confd \
  && mkdir -pv /etc/confd/{conf.d,templates} \
  && mkdir /etc/pgbouncer \
  && chown -R postgres /etc/confd \
  && chown -R postgres /usr/local/bin/confd \
  && chown -R postgres /etc/pgbouncer \
  && chmod +x /etc/confd/conf.d/pgb_update.sh
ADD entrypoint.sh /entrypoint.sh
RUN chown postgres /entrypoint.sh
USER postgres
VOLUME pgb /etc/pgbouncer/
ENTRYPOINT ["/entrypoint.sh"]
