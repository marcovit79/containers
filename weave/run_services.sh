
vagrant ssh vm1  -c "docker stop postgres1 && docker rm postgres1"
vagrant ssh vm1  -c "\$( ./weave env ) && docker run -d -e POSTGRES_PASSWORD=a1 --name postgres1 postgres"

vagrant ssh vm2  -c "docker stop postgres2 && docker rm postgres2"
vagrant ssh vm2  -c "\$( ./weave env ) && docker run -d -e POSTGRES_PASSWORD=b2 --name postgres2 postgres"


# Wait for service activation
sleep 10

# List DNS  gli indirizzi cambiano in base hai restart questo script va spostato sullàhost usando dig
vagrant ssh vm1  -c " echo \"\" > hosts_addition.txt "
vagrant ssh vm1  -c "( ./weave dns-lookup postgres1 | tr -d \"\\n\" && echo \"  postgres1  postgres1.weave.local\" ) >> hosts_addition.txt "
vagrant ssh vm1  -c "( ./weave dns-lookup postgres2 | tr -d \"\\n\" && echo \"  postgres2  postgres2.weave.local\" ) >> hosts_addition.txt "
vagrant ssh vm1  -c "cat hosts_addition.txt "

