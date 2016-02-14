vagrant ssh vm1 -c "docker pull mvit79/gluster-spark:spark-node"

vagrant ssh vm1 -c "docker stop spark-master ; docker rm spark-master"
vagrant ssh vm1 -c "\$( ./weave env ) && \
                    docker run \
                           --privileged \
                           --name spark-master -d \
                           mvit79/gluster-spark:spark-node \
                           --gluster-fs=glusterserver1:spark_fs"

vagrant ssh vm1 -c "docker stop spark-worker1 ; docker rm spark-worker1"
vagrant ssh vm1 -c "\$( ./weave env ) && \
                    docker run \
                           --privileged \
                           --name spark-worker1 -d \
                           mvit79/gluster-spark:spark-node \
                           --gluster-fs=glusterserver1:spark_fs \
                           --spark-master=spark-master.weave.local"
