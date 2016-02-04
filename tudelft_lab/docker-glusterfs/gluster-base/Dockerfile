FROM debian:jessie

RUN apt-get update \
    && apt-get upgrade -y -q \
    && apt-get install -y -q wget \
    && wget -O - http://download.gluster.org/pub/gluster/glusterfs/3.7/3.7.2/Debian/jessie/pub.key \
            | apt-key add - \
    && echo deb http://download.gluster.org/pub/gluster/glusterfs/3.7/3.7.2/Debian/jessie/apt jessie main \
        > /etc/apt/sources.list.d/gluster.list \
    && apt-get update -y -q \
    \
    \
    \
    && apt-get upgrade -y \
    && apt-get clean -y  \
    && apt-get autoclean -y  \
    && apt-get autoremove -y  \
    && rm -rf /usr/share/locale/*  \
    && rm -rf /var/cache/debconf/*-old  \
    && rm -rf /var/lib/apt/lists/*  \
    && rm -rf /usr/share/doc/*