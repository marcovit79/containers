#!/bin/bash
trap '/tmp/spark/spark/sbin/stop-slave.sh; /tmp/spark/spark/sbin/stop-master.sh; exit' TERM

SERVER_NAME=$1

echo "Mount spark_fs"
sudo mount /mnt/spark_fs/

echo "Starting spark with parameters $1 $2"

/tmp/spark/spark/sbin/stop-slave.sh
/tmp/spark/spark/sbin/stop-master.sh

/tmp/spark/spark/sbin/start-master.sh
/tmp/spark/spark/sbin/start-slave.sh spark://${SERVER_NAME}:7077



# keep live the container - bash check signals only between sleep
while :; do sleep 5; done  
