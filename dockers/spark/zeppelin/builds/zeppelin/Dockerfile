FROM ubuntu:trusty

# - Add repository for oracle java
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
         | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
         | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 

# - Update source repository information
RUN apt-get update && apt-get upgrade -y -q 


# - install oracle java (accepting the license)
RUN apt-get -y -q update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true \
         | /usr/bin/debconf-set-selections && \
    apt-get install -y -q oracle-java8-installer && \
    update-java-alternatives -s java-8-oracle 

# - install software needed to build zeppelin    
RUN apt-get install -y -q nodejs npm libfontconfig git wget \
    && cd /usr/bin/ && ln -s nodejs node \
    && npm install -g bower \
    && npm install -g grunt

#     install maven
RUN wget http://www.eu.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz \
    && tar -zxf apache-maven-3.3.3-bin.tar.gz -C /usr/local/ \
    && ln -s /usr/local/apache-maven-3.3.3/bin/mvn /usr/local/bin/mvn

RUN useradd -ms /bin/bash builder
USER builder
WORKDIR /home/builder

# - clone zeppelin
RUN git clone https://github.com/apache/incubator-zeppelin.git zeppelin_code \
    && cd zeppelin_code \
    && git checkout v0.5.6

# - Build zeppelin
RUN cd zeppelin_code \
    && \
    ( \
    	mvn clean package -DskipTests -Dspark.version=1.5.1 -Pspark-1.5 -Phadoop-2.6 \
                         -Pbuild-distr \
                         ||   \
      mvn package -DskipTests -Dspark.version=1.5.1 -Pspark-1.5 -Phadoop-2.6 \
                         -Pbuild-distr \
    )

RUN cp zeppelin_code/zeppelin-distribution/target/zeppelin-0.5.6-incubating.tar.gz \
       zeppelin-0.5.6-incubating.tar.gz
