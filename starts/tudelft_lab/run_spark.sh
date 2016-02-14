vagrant ssh vm1 -c "docker pull mvit79/gluster-spark:spark-node"

vagrant ssh vm1 -c "docker stop spark-master ; docker rm spark-master"
vagrant ssh vm1 -c "\$( ./weave env ) && \
                    docker run \
                           --add-host gluster-seed-server:\$( ./weave dns-lookup glusterserver1 ) \
                           --privileged \
                           --name spark-master -d mvit79/gluster-spark:spark-node "

vagrant ssh vm1 -c "docker stop spark-worker1 ; docker rm spark-worker1"
vagrant ssh vm1 -c "\$( ./weave env ) && \
                    docker run \
                           --add-host gluster-seed-server:\$( ./weave dns-lookup glusterserver1 ) \
                           --privileged \
                           --name spark-worker1 -d mvit79/gluster-spark:spark-node \
                           spark-master.weave.local"
