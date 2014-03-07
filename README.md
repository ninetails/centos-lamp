# ninetails/centos-lamp for docker

## cleanup
docker stop $(docker ps -a -q); docker rm $(docker ps -a -q)

## build
docker build --rm=true -t ninetails/centos-lamp . < Dockerfile

## run
docker run -i -t -p 8080:80 -v ${PWD}:/var/www:ro ninetails/centos-lamp
