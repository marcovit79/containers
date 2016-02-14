#!/bin/bash
trap '/tmp/spark/spark/sbin/stop-slave.sh; /tmp/spark/spark/sbin/stop-master.sh; exit' TERM

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


echo "Starting spark with master ${SPARK_MASTER_SERVER_NAME} "
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
