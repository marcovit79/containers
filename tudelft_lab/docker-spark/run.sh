#!/bin/bash
trap '/tmp/spark/spark/sbin/stop-slave.sh; /tmp/spark/spark/sbin/stop-master.sh; exit' TERM

SERVER_NAME=$1
GLUSTER_SERVER=$2

echo "Starting spark with parameters $1 $2"

mkdir -p /mnt/spark_fs
mount -t glusterfs ${GLUSTER_SERVER}:spark_fs /mnt/spark_fs

/tmp/spark/spark/sbin/stop-slave.sh
/tmp/spark/spark/sbin/stop-master.sh

/tmp/spark/spark/sbin/start-master.sh
/tmp/spark/spark/sbin/start-slave.sh spark://${SERVER_NAME}:7077



# keep live the container - bash check signals only between sleep
while :; do sleep 5; done  
