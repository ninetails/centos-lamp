# ninetails/centos-lamp for docker

## cleanup

    docker stop $(docker ps -a -q); docker rm $(docker ps -a -q)

## build

    docker build --rm=true -t ninetails/centos-lamp . < Dockerfile

## run

    docker run -i -t -p 80:80 -p 3306:3306 -p 2222:22 -v ${PWD}:/var/www:rw ninetails/centos-lamp

Change -p 8080:80 if you already uses port 80 on your host (e.g: have Apache installed on host)

## sometimes you need to run docker daemon

    sudo docker -d -e lxc

## remember

If you plan to use sshd, remember that:
- Find ip using ifconfig (docker0 adapter)
- connect using **ssh root@<ip> -p 2222**
- Perharps you may need to remove host from ~/.ssh/known_hosts
