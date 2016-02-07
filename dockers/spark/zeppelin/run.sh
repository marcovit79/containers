#!/bin/bash
trap '/home/zeppelin/zeppelin_installation/bin/zeppelin-daemon.sh stop ; exit' TERM

echo "Mount spark_fs"
sudo mount /mnt/spark_fs/

echo "Start zeppelin"
zeppelin_installation/bin/zeppelin-daemon.sh start

# keep live the container - bash check signals only between sleep
while :; do sleep 5; echo "running"; done  
