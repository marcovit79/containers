FROM debian:jessie

# - Update distro
RUN apt-get update && apt-get upgrade -y 

# - Add repository for gluster client
RUN	apt-get -y -q install curl && \
    curl http://download.gluster.org/pub/gluster/glusterfs/3.7/3.7.2/Debian/jessie/pub.key \
         | apt-key add - && \
	echo deb http://download.gluster.org/pub/gluster/glusterfs/3.7/3.7.2/Debian/jessie/apt jessie main \
	     > /etc/apt/sources.list.d/gluster.list

# - Add repository for oracle java
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
         | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
         | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 

# - Download package information from added repositories
RUN apt-get -y -q update


# - install oracle java	(accepting the license)
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true \
         | /usr/bin/debconf-set-selections && \
    apt-get install -y -q oracle-java8-installer && \
    update-java-alternatives -s java-8-oracle

# - install gluster client and other packages
RUN apt-get install -y -q glusterfs-client xfsprogs htop git

# - download spark components
RUN mkdir /tmp/spark && cd /tmp/spark && \
    curl http://ftp.tudelft.nl/apache/spark/spark-1.5.1/spark-1.5.1-bin-hadoop2.6.tgz \
         | tar xvz && mv spark-1.5.1-bin-hadoop2.6 spark && \
    cd /tmp/spark/spark/lib && \
    curl -O http://central.maven.org/maven2/org/gluster/glusterfs-hadoop/2.3.13/glusterfs-hadoop-2.3.13.jar

ADD core-site.xml /tmp/spark/spark/conf
ADD spark-env.sh /tmp/spark/spark/conf

#http://central.maven.org/maven2/org/postgresql/postgresql/9.4-1202-jdbc41/postgresql-9.4-1202-jdbc41.jar


ADD run.sh /scripts/
RUN chmod u+x /scripts/run.sh
ENTRYPOINT ["/scripts/run.sh"]