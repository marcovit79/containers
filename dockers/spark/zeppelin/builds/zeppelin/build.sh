# - install software needed to build zeppelin
      apt-get install -y -q nodejs npm libfontconfig git wget
      
      cd /usr/bin/ && ln -s nodejs node \
      && npm install -g bower \
      && npm install -g grunt
      
      #     install maven
      wget http://www.eu.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz \
      && tar -zxf apache-maven-3.3.3-bin.tar.gz -C /usr/local/ \
      && ln -s /usr/local/apache-maven-3.3.3/bin/mvn /usr/local/bin/mvn


# - clone zeppelin
git clone https://github.com/apache/incubator-zeppelin.git zeppelin_code \
    && cd zeppelin_code \
    && git checkout v0.5.6

# - Build zeppelin
cd zeppelin_code \
    && 
    (
    	mvn clean package -DskipTests -Dspark.version=1.5.1 -Pspark-1.5 -Phadoop-2.6 \
                         -Pbuild-distr \
                         ||   \
      mvn clean package -DskipTests -Dspark.version=1.5.1 -Pspark-1.5 -Phadoop-2.6 \
                         -Pbuild-distr \
    )
