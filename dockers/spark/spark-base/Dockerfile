FROM mvit79/glusterfs-client

# - Add repository for oracle java
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
         | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
         | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 

# - install oracle java	(accepting the license)
RUN apt-get -y -q update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true \
         | /usr/bin/debconf-set-selections && \
    apt-get install -y -q oracle-java8-installer && \
    update-java-alternatives -s java-8-oracle \
    \
    && apt-get clean -y  \
    && apt-get autoclean -y  \
    && apt-get autoremove -y  \
    && rm -rf /usr/share/locale/*  \
    && rm -rf /var/cache/debconf/*-old  \
    && rm -rf /var/lib/apt/lists/*  \
    && rm -rf /usr/share/doc/* \
    \
    \
    &&  \
    \
    mkdir -p /mnt/spark_fs \
    && echo "\ngluster-seed-server:spark_fs /mnt/spark_fs glusterfs defaults,_netdev 0 0" >> /etc/fstab \
    && echo "mount /mnt/spark_fs" >> /mnt/mountspark.sh \
    && chmod a+x /mnt/mountspark.sh \
    && chmod a+s /mnt/mountspark.sh


RUN useradd -ms /bin/bash spark
USER spark
WORKDIR /home/spark

# - download spark components
RUN wget -qO- http://ftp.tudelft.nl/apache/spark/spark-1.5.1/spark-1.5.1-bin-hadoop2.6.tgz \
         | tar xvz && mv spark-1.5.1-bin-hadoop2.6 spark && \
    cd spark/lib && \
    wget http://central.maven.org/maven2/org/gluster/glusterfs-hadoop/2.3.13/glusterfs-hadoop-2.3.13.jar

# - config spark
ADD core-site.xml spark/conf
ADD spark-env.sh spark/conf
