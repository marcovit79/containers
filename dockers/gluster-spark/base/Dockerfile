FROM debian:jessie

ENV GLUSTER_VERSION=3.7.2

# - Update and upgrade packages
# - Define GlusterFS repositories
# - Add glusterFS repositories
# - Add oracle java 8 repositories
# - Install gluster common packages
# - Reduce image size
RUN apt-get update \
    && apt-get upgrade -y -q \
    && apt-get install -y -q wget \
    \
    \
    && GLUSTER_REPO_BASE_URL="http://download.gluster.org/pub/gluster/glusterfs" \
    && GLUSTER_REPO_VERSION="${GLUSTER_VERSION%\.[0-9]*}/${GLUSTER_VERSION}/" \
    && GLUSTER_REPO_URL="${GLUSTER_REPO_BASE_URL}/${GLUSTER_REPO_VERSION}/Debian/jessie" \
    \
    \
    && wget -O - "${GLUSTER_REPO_URL}/pub.key" | apt-key add - \
    && echo deb "${GLUSTER_REPO_URL}/apt jessie main" > /etc/apt/sources.list.d/gluster.list \
    && apt-get update -y -q \
    \
    \
    && echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" \
         | tee /etc/apt/sources.list.d/webupd8team-java.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
    \
    \
    && apt-get install -q -y glusterfs-common \
    \
    \
    && apt-get upgrade -y \
    && apt-get clean -y  \
    && apt-get autoclean -y  \
    && apt-get autoremove -y  \
    && rm -rf /usr/share/locale/*  \
    && rm -rf /var/cache/debconf/*-old  \
    && rm -rf /var/lib/apt/lists/*  \
    && rm -rf /usr/share/doc/*