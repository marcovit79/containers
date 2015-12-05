vagrant ssh vm1  -c "./weave launch --init-peer-count 2"
vagrant ssh vm1  -c "./scope launch"


vagrant ssh vm2  -c "./weave launch --init-peer-count 2"
vagrant ssh vm2  -c "./scope launch"

vagrant ssh vm2  -c "./weave connect  192.168.33.11"
vagrant ssh vm1  -c "./weave expose"

vagrant ssh vm1  -c "sudo /vagrant/runvpn_from_machine.sh 192.168.33.11"
vagrant ssh vm1  -c "sudo service openvpn restart"
vagrant ssh vm1  -c "cp /etc/openvpn/client.ovpn /vagrant"

