FROM centos

MAINTAINER Ninetails - Carlos Kazuo

# install
RUN rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
RUN curl -s http://repos.fedorapeople.org/repos/jkaluza/httpd24/epel-httpd24.repo > /etc/yum.repos.d/epel-httpd24.repo
RUN yum install -y xterm git mysql mysql-server httpd24-httpd php55w php55w-common php55w-cli mysql mysql-server php55w-devel php55w-mcrypt php55w-mbstring php55w-mysqlnd php55w-pdo php55w-pecl-xdebug php55w-xml php55w-xmlrpc php55w-opcache

RUN echo "NETWORKING=yes" > /etc/sysconfig/network
RUN sed -i "s/^bind-address/#bind-address/" /etc/my.cnf
RUN ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock
RUN /sbin/service mysqld start; /usr/bin/mysqladmin -u root password "123456"; /usr/bin/mysql -uroot -p123456 -e "CREATE DATABASE dev; CREATE USER 'dev'@'localhost' IDENTIFIED BY '123456'; GRANT ALL PRIVILEGES ON dev.* TO 'dev'@'localhost'; FLUSH PRIVILEGES;"

RUN echo "/sbin/service mysqld start" >> /root/.bashrc
RUN echo "/sbin/service httpd start" >> /root/.bashrc
ENTRYPOINT ["/bin/bash"]
