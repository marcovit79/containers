vagrant ssh vm1 -c "docker build --rm -t spark-standalone /docker_build/docker-spark"

vagrant ssh vm1 -c "docker stop spark-master && docker rm spark-master"

vagrant ssh vm1 -c "\$( ./weave env ) && \
                    docker run --privileged --name spark-master -d spark-standalone \
                           spark-master.weave.local glusterserver1"

