FROM alpine
ARG PGBVERSION=1.15.0

#https://github.com/gmr/alpine-pgbouncer/blob/master/Dockerfile
RUN \
  apk update \
  && apk upgrade --available \
  && apk add autoconf autoconf-doc automake udns udns-dev curl gcc libc-dev libevent libevent-dev libtool make openssl-dev pkgconfig postgresql-client \
  && curl -o  /tmp/pgbouncer-${PGBVERSION}.tar.gz -L https://pgbouncer.github.io/downloads/files/${PGBVERSION}/pgbouncer-${PGBVERSION}.tar.gz \
  && cd /tmp \
  && tar xvfz /tmp/pgbouncer-${PGBVERSION}.tar.gz \
  && cd pgbouncer-${PGBVERSION} \
  && ./configure --prefix=/usr --with-udns \
  && make \
  && cp pgbouncer /usr/bin \
  && mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer \
  && cp etc/pgbouncer.ini /etc/pgbouncer/pgbouncer.ini \
  && cp etc/userlist.txt /etc/pgbouncer/userlist.txt \
  && addgroup -g 70 -S postgres \
  && adduser -S postgres -G postgres \
  && chown -R postgres /var/run/pgbouncer /etc/pgbouncer \
  && ln -s /dev/null /var/log/pgbouncer/pgbouncer.log \
  && cd /tmp \
  && rm -rf /tmp/pgbouncer* \
  && apk del --purge autoconf autoconf-doc automake udns-dev gcc libc-dev libevent-dev libtool make libressl-dev pkgconfig 
ADD entrypoint.sh /entrypoint.sh
RUN chown postgres /entrypoint.sh
USER postgres
#EXPOSE 5432
VOLUME pgb /etc/pgbouncer/
ENTRYPOINT ["/entrypoint.sh"]
