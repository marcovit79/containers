#!/bin/bash
trap '/tmp/spark/spark/sbin/stop-slave.sh; /tmp/spark/spark/sbin/stop-master.sh; exit' TERM

. "$(dirname $0)/prepare_spark_env.sh"


# - Parse arguments for spark. If parameters specify a spark-master this node is spark worker
SPARK_MASTER_SERVER_NAME=""

for arg in "$@"
do
	case $arg in
		--spark-master=*)
			SPARK_MASTER_SERVER_NAME=${arg#--spark-master=}
		;;
	esac
done


export SPARK_HOME="${HOME}/spark/"
echo "SPARK_HOME = \"${SPARK_HOME}\""

echo "Prepare GlusterFS-HDFS config"
cat /etc/spark/core-site.xml.template | sed -e "s|SPARK_FS_PATH|${SPARK_FS_MOUNT_POINT}|" \
                                      > ${SPARK_HOME}/conf/core-site.xml


echo "Starting spark with master ${SPARK_MASTER_SERVER_NAME} "
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
