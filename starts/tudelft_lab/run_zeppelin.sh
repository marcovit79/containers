vagrant ssh vm2 -c "docker pull mvit79/spark-zeppelin"

vagrant ssh vm2 -c "docker stop zeppelin1 ; docker rm zeppelin1"

vagrant ssh vm2 -c "\$( ./weave env ) && \
                    docker run -d \
                          --add-host gluster-seed-server:\$( ./weave dns-lookup glusterserver2 ) \
                          --privileged \
                          --name zeppelin1 \
                          mvit79/spark-zeppelin spark-master"

