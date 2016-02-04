BASE_BUILD_DIR="/docker_build/"

vagrant up
vagrant ssh vmb -c "sh /vagrant/build_docker_images_invm.sh ${BASE_BUILD_DIR} $*"



