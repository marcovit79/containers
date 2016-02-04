#!/bin/bash
trap 'service glusterfs-server stop; exit' TERM

service glusterfs-server start
sleep 10

gluster peer probe $1
sleep 5


if ( [ "x$2" = "xstart"  ] ) then
	gluster volume create spark_fs glusterserver1:/glusterd/spark_fs glusterserver2:/glusterd/spark_fs  
	sleep 2
	gluster volume start spark_fs
fi




# keep live the container - bash check signals only between sleep
while :; do gluster pool list; sleep 5; gluster volume info; sleep 5; done  
