vagrant ssh vm1 -c "\$( ./weave env ) && \
    docker exec spark-master bash -c \"( \
          cd /mnt/spark_fs && \
          ( \
          	rm iris.data 2015-01-01-15.json.gz ;
          	wget https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data	;
          	wget http://data.githubarchive.org/2015-01-01-15.json.gz
          )
    )\" "

