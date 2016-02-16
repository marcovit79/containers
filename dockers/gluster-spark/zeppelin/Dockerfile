FROM mvit79/gluster-spark:spark-base

# - Create zeppelin user with passwordless sudo. The passwordless sudo is needed 
#    by the GlusterFS-HDFS implementation
RUN useradd -ms /bin/bash zeppelin && echo "zeppelin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER zeppelin
WORKDIR /home/zeppelin

COPY builds/*.tar.gz /tmp/zeppelin-tgz/

# - decompress zeppelin and remove tar file
# - add extension
RUN tar xvzf /tmp/zeppelin-tgz/*.tar.gz \
    && sudo rm -rf /tmp/zeppelin-tgz/ \
    && mv zeppelin-* zeppelin \
    \
    \
    && cd zeppelin/interpreter/spark/dep \
    && mkdir extension && cd extension \
    && for url in "$SPARK_INTERNAL_EXTENSIONS_URLS" ; do \
       wget -O - $url | jar x ; \
    done \
    && cd .. && jar uf zeppelin-spark-dependencies-*.jar -C extension . 

COPY run.sh /scripts/
RUN sudo chmod a+x /scripts/run.sh

ENTRYPOINT ["/usr/bin/dumb-init", "/scripts/run.sh"]
