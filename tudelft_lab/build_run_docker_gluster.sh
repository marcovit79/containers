vagrant ssh vm1 -c "mkdir -p /home/vagrant/gluster1/data/spark_fs && \
                    mkdir -p /home/vagrant/gluster1/info"
vagrant ssh vm1 -c "mkdir -p /home/vagrant/gluster2/data/spark_fs && \
                    mkdir -p /home/vagrant/gluster2/info"


vagrant ssh vm1 -c "docker pull mvit79/glusterfs-server && \
                    docker stop glusterserver1 && docker rm glusterserver1"
vagrant ssh vm2 -c "docker pull mvit79/glusterfs-server && \
                    docker stop glusterserver2 && docker rm glusterserver2"

vagrant ssh vm1 -c "\$( ./weave env ) && \
docker run --privileged -d --name glusterserver1         \
	-v /home/vagrant/gluster1/data/:/glusterd/           \
	-v /home/vagrant/gluster1/info/:/var/lib/glusterd/   \
	mvit79/glusterfs-server glusterserver2 "

vagrant ssh vm2 -c "\$( ./weave env ) && \
docker run --privileged -d --name glusterserver2         \
	-v /home/vagrant/gluster2/data/:/glusterd/           \
	-v /home/vagrant/gluster2/info/:/var/lib/glusterd/   \
	mvit79/glusterfs-server glusterserver1 start "
