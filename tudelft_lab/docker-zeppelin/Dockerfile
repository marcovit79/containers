FROM debian:jessie

# - Add repository for oracle java
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
         | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
         | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 


# - Update distribution 
RUN apt-get -y -q update && apt-get upgrade


# - install oracle java	(accepting the license)
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true \
         | /usr/bin/debconf-set-selections && \
    apt-get install -y -q oracle-java8-installer && \
    update-java-alternatives -s java-8-oracle

# - install base software
RUN apt-get install -y -q wget git

# - install software needed to build zeppelin
RUN apt-get install -y -q nodejs npm libfontconfig \
    && cd /usr/bin/ && ln -s nodejs node \
    && npm install -g bower \
    && npm install -g grunt
 

#      install maven
RUN wget http://www.eu.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz \
    && tar -zxf apache-maven-3.3.3-bin.tar.gz -C /usr/local/ \
    && ln -s /usr/local/apache-maven-3.3.3/bin/mvn /usr/local/bin/mvn


RUN useradd -ms /bin/bash zeppelin
USER zeppelin
WORKDIR /home/zeppelin

# - Download zeppelin code
RUN git clone https://github.com/apache/incubator-zeppelin.git zeppelin_code \
    && cd zeppelin_code \
    && git checkout v0.5.6


# - Build zeppelin
RUN cd zeppelin_code \
    && mvn clean package -DskipTests -Dspark.version=1.5.1 -Pspark-1.5 -Phadoop-2.6 \
                         -Pbuild-distr

# - install zeppelin
RUN cp zeppelin_code/zeppelin-distribution/target/zeppelin-0.5.6-incubating.tar.gz . \
    && tar xvzf zeppelin-0.5.6-incubating.tar.gz \
    && ln -s zeppelin-0.5.6-incubating zeppelin_installation \
    && rm zeppelin-0.5.6-incubating.tar.gz

# - remove compilarion directori
#RUN rm -rf zeppelin_code

ADD run.sh /scripts/
RUN chmod u+x /scripts/run.sh
ENTRYPOINT ["/scripts/run.sh"]

