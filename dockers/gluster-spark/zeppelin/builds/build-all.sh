echo "### STARTING ZEPPELIN BUILD ####"

docker build --rm=true -t zeppelin-build ./zeppelin

docker stop zeppelin-build-container
docker rm zeppelin-build-container

file=$( docker run --name zeppelin-build-container zeppelin-build ls | grep tar.gz )
docker cp zeppelin-build-container:/home/builder/$file .

docker stop zeppelin-build-container
docker rm zeppelin-build-container


