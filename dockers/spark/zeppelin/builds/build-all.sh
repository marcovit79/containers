echo "### STARTING ZEPPELIN BUILD ####"

docker build --rm=true -t zeppelin-build ./zeppelin

docker stop zeppelin-build-container
docker rm zeppelin-build-container

docker run --name zeppelin-build-container zeppelin-build ls
docker cp zeppelin-build-container:/home/builder/zeppelin-0.5.6-incubating.tar.gz .

docker stop zeppelin-build-container
docker rm zeppelin-build-container


