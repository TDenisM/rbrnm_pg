ARG PG_MAJOR=13
ARG COMPRESS=false
ARG PGHOME=/home/postgres
ARG PGDATA=$PGHOME/data
ARG LC_ALL=C.UTF-8
ARG LANG=C.UTF-8

FROM postgres:$PG_MAJOR as builder

ARG PGHOME
ARG PGDATA
ARG LC_ALL
ARG LANG

RUN set -ex \
    && export DEBIAN_FRONTEND=noninteractive \
    && echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommend \
    && apt-get update -y \
    # postgres:10 is based on debian, which has the patroni package. We will install all required dependencies
    && apt-cache depends patroni | sed -n -e 's/.*Depends: \(python3-.\+\)$/\1/p' \
            | grep -Ev '^python3-(etcd)' \
            | xargs apt-get install -y nano curl less jq locales sudo \
                            python3-etcd python3-pip busybox \
                            net-tools iputils-ping --fix-missing \
    && pip3 install dumb-init \
    && find /usr/share/i18n/charmaps/ -type f ! -name UTF-8.gz -delete \
    && find /usr/share/i18n/locales/ -type f ! -name en_US ! -name en_GB ! -name i18n* ! -name iso14651_t1 ! -name iso14651_t1_common ! -name 'translit_*' -delete \
    && echo 'en_US.UTF-8 UTF-8' > /usr/share/i18n/SUPPORTED \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && mkdir -p $PGHOME/.config/patroni /patroni \
    && ln -s ../../postgres0.yml $PGHOME/.config/patroni/patronictl.yaml \
    && ln -s /patronictl.py /usr/local/bin/patronictl \
    && sed -i "s|/var/lib/postgresql.*|$PGHOME:/bin/bash|" /etc/passwd \
    && chown -R postgres:postgres /var/log \
    && apt-get purge -y --allow-remove-essential python3-pip gzip bzip2 util-linux e2fsprogs \
                libmagic1 bsdmainutils login ncurses-bin libmagic-mgc e2fslibs bsdutils \
                exim4-config gnupg-agent dirmngr libpython2.7-stdlib libpython2.7-minimal \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
        /root/.cache \
        /var/cache/debconf/* \
        /etc/rc?.d \
        /etc/systemd \
        /docker-entrypoint* \
        /sbin/pam* \
        /sbin/swap* \
        /sbin/unix* \
        /usr/local/bin/gosu \
        /usr/sbin/[acgipr]* \
        /usr/sbin/*user* \
        /usr/share/doc* \
        /usr/share/man \
        /usr/share/info \
        /usr/share/i18n/locales/translit_hangul \
        /usr/share/locale/?? \
        /usr/share/locale/??_?? \
        /usr/share/postgresql/*/man \
        /usr/share/postgresql-common/pg_wrapper \
        /usr/share/vim/vim80/doc \
        /usr/share/vim/vim80/lang \
        /usr/share/vim/vim80/tutor \
    && find /usr/bin -xtype l -delete \
    && find /var/log -type f -exec truncate --size 0 {} \; \
    && find /usr/lib/python3/dist-packages -name '*test*' | xargs rm -fr \
    && find /lib/x86_64-linux-gnu/security -type f ! -name pam_env.so ! -name pam_permit.so ! -name pam_unix.so -delete


FROM scratch
COPY --from=builder / /

LABEL maintainer="Alexander Kukushkin <alexander.kukushkin@zalando.de>"

ARG PG_MAJOR
ARG COMPRESS
ARG PGHOME
ARG PGDATA
ARG LC_ALL
ARG LANG

ARG PGBIN=/usr/lib/postgresql/$PG_MAJOR/bin

ENV LC_ALL=$LC_ALL LANG=$LANG EDITOR=/usr/bin/editor
ENV PGDATA=$PGDATA PATH=$PATH:$PGBIN

COPY patroni /patroni/
COPY patroni*.py entrypoint.sh /
COPY postgres?.yml $PGHOME/

WORKDIR $PGHOME

USER postgres

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
