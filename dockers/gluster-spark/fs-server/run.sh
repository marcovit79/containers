#!/bin/bash
trap 'service glusterfs-server stop; exit' TERM

echo "service glusterfs-server start"
service glusterfs-server start

PROBES=()
ACTION="NONE"
VOLUME=""
VOLUME_PATH=""

for arg in "$@"
do
	case $arg in
		--start-vol=*)
			ACTION="START"
			vol_and_path=${arg#--start-vol=}
			VOLUME=${vol_and_path%:*}
			VOLUME_PATH=${arg#--start-vol=[^:]*:}
		;;
		*)
			PROBES+=($arg)
		;;
	esac
done

echo "Wait for other server start"
sleep $(( 5 * ${#PROBES[@]} ))

probe_with_path=()
for probe in "${PROBES[@]}"
do
	probe_with_path+=("$probe:$VOLUME_PATH")
	echo "gluster peer probe $probe"
	gluster peer probe $probe
done

sleep 5

if ( [ "${ACTION}" = "START"  ] ) then
	echo "STARTING... $VOLUME $VOLUME_PATH ON ${PROBES[@]}";
	echo "gluster volume create $VOLUME ${probe_with_path[@]}"
	gluster volume create $VOLUME ${probe_with_path[@]}
	sleep 5
	echo "gluster volume start $VOLUME"
	gluster volume start $VOLUME
fi




# keep live the container - bash check signals only between sleep
while :; do gluster pool list; sleep 5; gluster volume info; sleep 5; done  
