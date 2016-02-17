vagrant ssh vm2 -c "docker pull mvit79/gluster-spark:zeppelin"

vagrant ssh vm2 -c "docker stop zeppelin1 ; docker rm zeppelin1"

vagrant ssh vm2 -c "\$( ./weave env ) && \
                    docker run -d \
                           --privileged \
                           --name zeppelin1 -d \
                           mvit79/gluster-spark:zeppelin \
                           --gluster-fs=glusterserver2:spark_fs \
                           --spark-master=spark-master.weave.local"

