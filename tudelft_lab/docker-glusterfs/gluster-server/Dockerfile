FROM mvit79/glusterfs-base


RUN apt-get update && apt-get install -y glusterfs-server xfsprogs \
    \
    && apt-get clean -y  \
    && apt-get autoclean -y  \
    && apt-get autoremove -y  \
    && rm -rf /usr/share/locale/*  \
    && rm -rf /var/cache/debconf/*-old  \
    && rm -rf /var/lib/apt/lists/*  \
    && rm -rf /usr/share/doc/*


ADD run.sh /scripts/
RUN chmod u+x /scripts/run.sh
ENTRYPOINT ["/scripts/run.sh"]