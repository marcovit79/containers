FROM mvit79/gluster-spark:spark-base

ENV ZEPPELIN_VERSION=0.5.6 \
    MAVEN_VERSION=3.3.3

# - build package list
RUN apt-get update

# - Prepare maven url
# - Download and install maven
RUN mvn_tgz_name="apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
 && mvn_mirror="http://www.eu.apache.org/" \
 && mvn_path="dist/maven/maven-${MAVEN_VERSION%%\.*}/${MAVEN_VERSION}/binaries/" \
 && mvn_url="${mvn_mirror}${mvn_path}${mvn_tgz_name}" \
 \
 && wget -O - ${mvn_url} | tar zx -C /usr/local/ \
 && ln -s /usr/local/apache-maven-3.3.3/bin/mvn /usr/local/bin/mvn

# - install other software needed to build zeppelin    
RUN apt-get install -y -q nodejs npm libfontconfig git wget \
 && cd /usr/bin/ && ln -s nodejs node \
 && npm install -g bower \
 && npm install -g grunt


RUN useradd -ms /bin/bash builder
USER builder
WORKDIR /home/builder

# - clone zeppelin
RUN git clone https://github.com/apache/incubator-zeppelin.git zeppelin_code \
    && cd zeppelin_code \
    && git checkout v${ZEPPELIN_VERSION}

# - Build zeppelin
RUN cd zeppelin_code \
    && \
    ( \
    	mvn clean package -DskipTests \
                          -Dspark.version=${SPARK_VERSION} \
                          -Pspark-${SPARK_VERSION%\.[0-9]*} \
                          -Phadoop-${HADOOP_VERSION%\.[0-9]*} \
                          -Pbuild-distr \
        ||   \
        mvn package -DskipTests \
                    -Dspark.version=${SPARK_VERSION} \
                    -Pspark-${SPARK_VERSION%\.[0-9]*} \
                    -Phadoop-${HADOOP_VERSION%\.[0-9]*} \
                    -Pbuild-distr \
    )

RUN cp zeppelin_code/zeppelin-distribution/target/zeppelin-${ZEPPELIN_VERSION}-incubating.tar.gz \
       zeppelin-${ZEPPELIN_VERSION}.tar.gz
