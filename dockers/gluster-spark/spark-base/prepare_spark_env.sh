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
