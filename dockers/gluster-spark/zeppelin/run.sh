#!/bin/bash
trap '/home/zeppelin/zeppelin/bin/zeppelin-daemon.sh stop ; exit'  SIGTERM SIGINT SIGQUIT

# - Mount gluster and set env
. "$(dirname $0)/prepare_spark_env.sh"


export ZEPPELIN_HOME="${HOME}/zeppelin/"
echo "ZEPPELIN_HOME = \"${ZEPPELIN_HOME}\""

echo "Prepare GlusterFS-HDFS config"
ZEPPELIN_SPARK_CONF_DIR="${ZEPPELIN_HOME}/interpreter/spark/conf"
mkdir -p ${ZEPPELIN_SPARK_CONF_DIR}

cat /etc/spark/core-site.xml.template | sed -e "s|SPARK_FS_PATH|${SPARK_FS_MOUNT_POINT}|" \
                           > ${ZEPPELIN_SPARK_CONF_DIR}/core-site.xml

( cd "${ZEPPELIN_HOME}/interpreter/spark/dep" && jar uf zeppelin-spark-dependencies-*.jar -C ../conf . )

if ( [ "x" != "x${SPARK_MASTER_SERVER_NAME}" ] ) then
	echo "Have to config spark master pointer to ${SPARK_MASTER_SERVER_NAME}"

	if ( [ ! -e "${ZEPPELIN_HOME}/conf/interpreter.json" ] ) then
		# - If the interpreter.json do not exist start and stop zeppelin to create it
		${ZEPPELIN_HOME}/bin/zeppelin-daemon.sh start
		sleep 5
		${ZEPPELIN_HOME}/bin/zeppelin-daemon.sh stop
		sleep 5
	fi

	( cd "${ZEPPELIN_HOME}/conf/" \
		   && sed -i -e "s|\"local\\[\\*\\]\"|\"spark://${SPARK_MASTER_SERVER_NAME}:7077\"|" interpreter.json 
	)
fi

echo "Start zeppelin"
${ZEPPELIN_HOME}/bin/zeppelin-daemon.sh start

# keep live the container - bash check signals only between sleep
while :; do sleep 5; echo "running"; done  
