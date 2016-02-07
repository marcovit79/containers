FROM mvit79/spark-base

# - FIXME: That user switch is very weird see https://github.com/docker/docker/issues/7537
USER root

# - install zeppelin
ADD builds/zeppelin-0.5.6-incubating.tar.gz .
RUN chown -R spark:spark zeppelin-0.5.6-incubating \
 && ln -s zeppelin-0.5.6-incubating zeppelin_installation \
 && chown spark:spark zeppelin_installation

COPY run.sh /scripts/
RUN chmod a+x /scripts/run.sh 
USER spark

ENTRYPOINT ["/scripts/run.sh"]

