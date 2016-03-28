vagrant ssh vm1 -c "docker pull mvit79/4home:dontpanic ; \
                    docker stop dontpanic ; docker rm dontpanic"

# Execute dontpanic
vagrant ssh vm1 -c "\$( ./weave env ) && \
docker run --name dontpanic \
       -ti \
       -p 127.0.0.1:9090:9090 \
       mvit79/4home:dontpanic "
