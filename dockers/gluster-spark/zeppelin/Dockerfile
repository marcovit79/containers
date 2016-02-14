FROM mvit79/spark-base

# - FIXME: That user switch is very weird see https://github.com/docker/docker/issues/7537
USER root

# - install zeppelin
ADD builds/zeppelin-0.5.6-incubating.tar.gz .

# - add glusterfs
RUN cd zeppelin-0.5.6-incubating/interpreter/spark/dep && \
    wget http://central.maven.org/maven2/org/gluster/glusterfs-hadoop/2.3.13/glusterfs-hadoop-2.3.13.jar \
    && \
    jar xf  glusterfs-hadoop-2.3.13.jar && jar uf zeppelin-spark-dependencies-0.5.6-incubating.jar org -C /home/spark/spark/conf core-site.xml \
    && rm -rf org 

RUN chown -R spark:spark zeppelin-0.5.6-incubating \
 && ln -s zeppelin-0.5.6-incubating zeppelin_installation \
 && chown spark:spark zeppelin_installation

COPY run.sh /scripts/
RUN chmod a+x /scripts/run.sh 
USER spark

ENTRYPOINT ["/usr/bin/dumb-init", "/scripts/run.sh"]

