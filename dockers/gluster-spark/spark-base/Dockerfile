FROM mvit79/gluster-spark:base

ENV JAVA_VERSION=8
ENV SPARK_VERSION=1.5.1
ENV HADOOP_VERSION=2.6.0
ENV SPARK_INTERNAL_EXTENSIONS_URLS="http://central.maven.org/maven2/org/gluster/glusterfs-hadoop/2.3.13/glusterfs-hadoop-2.3.13.jar"

# - generate packages list
# - accept oracle java license
# - Install oracle java, gluster client, sudo and getfattr (used by the 
#   glusterfs HDFS client implementation).
# - Install dumb-init
# - clean image
RUN apt-get -y -q update \
    \
    \
    && accept_oracle_license_key="oracle-java${JAVA_VERSION}-installer shared/accepted-oracle-license-v1-1" \
    && echo $accept_oracle_license_key select true | /usr/bin/debconf-set-selections \
    \
    \
    && apt-get install -y -q oracle-java${JAVA_VERSION}-set-default sudo glusterfs-client xfsprogs \
    \
    \
    && wget https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64.deb \
    && dpkg -i dumb-init_*.deb \
    \
    \
    && apt-get clean -y  \
    && apt-get autoclean -y  \
    && apt-get autoremove -y  \
    && rm -rf /usr/share/locale/*  \
    && rm -rf /var/cache/debconf/*-old  \
    && rm -rf /var/lib/apt/lists/*  \
    && rm -rf /usr/share/doc/* \
    && rm /var/cache/oracle-jdk8-installer/*.tar.gz \
    && rm -rf /tmp/ && mkdir /tmp 

ADD core-site.xml.template /etc/spark/
