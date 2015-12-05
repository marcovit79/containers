
vagrant ssh vm1  -c "docker stop postgres1 && docker rm postgres1"
vagrant ssh vm1  -c "\$( ./weave env ) && docker run -d -e POSTGRES_PASSWORD=a1 --name postgres1 postgres"

vagrant ssh vm2  -c "docker stop postgres2 && docker rm postgres2"
vagrant ssh vm2  -c "\$( ./weave env ) && docker run -d -e POSTGRES_PASSWORD=b2 --name postgres2 postgres"

