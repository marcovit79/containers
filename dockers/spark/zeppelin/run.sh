#!/usr/bin/dumb-init /bin/bash
trap '/home/zeppelin/zeppelin_installation/bin/zeppelin-daemon.sh stop ; exit' TERM

echo "Mount spark_fs"
sudo mount /mnt/spark_fs/

echo "Start zeppelin"
if ( [ "x" != "x${1}"] ) then
	export MASTER=spark://${1}:7077
fi
zeppelin_installation/bin/zeppelin-daemon.sh start

# keep live the container - bash check signals only between sleep
while :; do sleep 5; echo "running"; done  
