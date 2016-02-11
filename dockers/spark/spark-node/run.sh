#!/usr/bin/dumb-init /bin/bash
trap '/tmp/spark/spark/sbin/stop-slave.sh; /tmp/spark/spark/sbin/stop-master.sh; exit' TERM

SPARK_MASTER_SERVER_NAME=$1

echo "Mount spark_fs"
sudo mount /mnt/spark_fs/

echo "Starting spark with parameters $1 $2"
export SPARK_HOME="${HOME}/spark/"

${HOME}/spark/sbin/stop-slave.sh
${HOME}/spark/sbin/stop-master.sh

if ( [ "x" = "x${SPARK_MASTER_SERVER_NAME}" ] ) then 
	${HOME}/spark/sbin/start-master.sh
else
	sleep 10
	${HOME}/spark/sbin/start-slave.sh spark://${SPARK_MASTER_SERVER_NAME}:7077
fi

sleep 10


# keep live the container - bash check signals only between sleep
while :; do sleep 5; done  
