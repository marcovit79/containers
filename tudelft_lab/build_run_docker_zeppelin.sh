vagrant ssh vm2 -c "docker build --rm -t zeppelin /docker_build/docker-zeppelin"

vagrant ssh vm2 -c "docker stop zeppelin1 && docker rm zeppelin1"

vagrant ssh vm2 -c "\$( ./weave env ) && \
                    docker run --name zeppelin1 -d zeppelin"

