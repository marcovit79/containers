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
