#!/bin/bash
trap '/home/zeppelin/zeppelin/bin/zeppelin-daemon.sh stop ; exit'  SIGTERM SIGINT SIGQUIT

# - Parse arguments for mounting gluster
GLUSTER_SEED_SERVER="gluster-seed-server"
GLUSTER_VOLUME="set-spark-volume"
SPARK_FS_MOUNT_POINT="/mnt/spark_fs"

for arg in "$@"
do
	case $arg in
		--gluster-fs=*)
			server_and_vol=${arg#--gluster-fs=}
			GLUSTER_SEED_SERVER=${server_and_vol%%:*}
			GLUSTER_VOLUME=${server_and_vol#[^:]*:}
		;;
		--gluster-fs-mount=*)
			SPARK_FS_MOUNT_POINT=${arg#--gluster-fs-mount=}
		;;
	esac
done

# - Mount gluster
echo "Mount ${GLUSTER_SEED_SERVER}:${GLUSTER_VOLUME} into ${SPARK_FS_MOUNT_POINT}"
sudo mkdir -p "${SPARK_FS_MOUNT_POINT}"
sudo mount -t glusterfs "${GLUSTER_SEED_SERVER}:${GLUSTER_VOLUME}" "${SPARK_FS_MOUNT_POINT}"





# - Get a spark master reference
SPARK_MASTER_SERVER_NAME=""

for arg in "$@"
do
	case $arg in
		--spark-master=*)
			SPARK_MASTER_SERVER_NAME=${arg#--spark-master=}
		;;
	esac
done


export ZEPPELIN_HOME="${HOME}/zeppelin/"
echo "ZEPPELIN_HOME = \"${ZEPPELIN_HOME}\""

echo "Prepare GlusterFS-HDFS config"
ZEPPELIN_SPARK_CONF_DIR="${ZEPPELIN_HOME}/interpreter/spark/conf"
mkdir -p ${ZEPPELIN_SPARK_CONF_DIR}

cat /etc/spark/core-site.xml.template | sed -e "s|SPARK_FS_PATH|${SPARK_FS_MOUNT_POINT}|" \
                           > ${ZEPPELIN_SPARK_CONF_DIR}/core-site.xml

( cd "${ZEPPELIN_HOME}/interpreter/spark/dep" && jar uf zeppelin-spark-dependencies-*.jar -C ../conf . )

if ( [ "x" != "x${SPARK_MASTER_SERVER_NAME}" ] ) then
	echo "Have to config spark master pointer"
fi

echo "Start zeppelin"
${ZEPPELIN_HOME}/bin/zeppelin-daemon.sh start

# keep live the container - bash check signals only between sleep
while :; do sleep 5; echo "running"; done  
