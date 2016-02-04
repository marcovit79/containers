FROM mvit79/glusterfs-base

# - install gluster client and other packages
RUN apt-get update && apt-get install -y -q glusterfs-client xfsprogs \
    \
    && apt-get clean -y  \
    && apt-get autoclean -y  \
    && apt-get autoremove -y  \
    && rm -rf /usr/share/locale/*  \
    && rm -rf /var/cache/debconf/*-old  \
    && rm -rf /var/lib/apt/lists/*  \
    && rm -rf /usr/share/doc/*

