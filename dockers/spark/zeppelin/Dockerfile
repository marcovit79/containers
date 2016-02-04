FROM mvit79/spark-base

# - install base software
RUN apt-get install -y -q wget 


# - install zeppelin
ADD builds/zeppelin/zeppelin_code/zeppelin-distribution/target/zeppelin-0.5.6-incubating.tar.gz \
    zeppelin-0.5.6-incubating.tar.gz
RUN tar xvzf zeppelin-0.5.6-incubating.tar.gz \
    && ln -s zeppelin-0.5.6-incubating zeppelin_installation \
    && rm zeppelin-0.5.6-incubating.tar.gz


ADD run.sh /scripts/
RUN chmod u+x /scripts/run.sh
ENTRYPOINT ["/scripts/run.sh"]

