FROM mvit79/gluster-spark:spark-base


# - Create spark user with passwordless sudo. The passwordless sudo is needed 
#    by the GlusterFS-HDFS implementation
RUN useradd -ms /bin/bash spark && echo "spark ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER spark
WORKDIR /home/spark

# - Prepare spark download url
# - Download and uncompress spark
# - download and incorporate internal spark extension (Es: GlusterFS-HDFS)
RUN hdp_ver=${HADOOP_VERSION%\.[0-9]*} \
    && apache_mirror="http://ftp.tudelft.nl/apache" \
    && spark_download_path="/spark/spark-${SPARK_VERSION}/" \
    && spark_download_file="spark-${SPARK_VERSION}-bin-hadoop${hdp_ver}.tgz" \
    && spark_download_url="${apache_mirror}${spark_download_path}${spark_download_file}" \
    \
    \
    && spark_dirname="spark-${SPARK_VERSION}-bin-hadoop${hdp_ver}" \
    && wget -O - ${spark_download_url} | tar xvz && mv ${spark_dirname} spark \
    \
    \
    && cd spark/lib \
    && mkdir extension && cd extension \
    && for url in "$SPARK_INTERNAL_EXTENSIONS_URLS" ; do \
       wget -O - $url | jar x ; \
    done \
    && cd .. && jar uf spark-assembly-${SPARK_VERSION}-hadoop${HADOOP_VERSION}.jar -C extension . 

COPY run.sh /scripts/
RUN sudo chmod a+x /scripts/run.sh

ENTRYPOINT ["/usr/bin/dumb-init", "/scripts/run.sh"]
