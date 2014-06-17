FROM centos

MAINTAINER Ninetails - Carlos Kazuo

RUN echo 'root:123456' | chpasswd

# install
RUN rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
RUN curl -s http://repos.fedorapeople.org/repos/jkaluza/httpd24/epel-httpd24.repo > /etc/yum.repos.d/epel-httpd24.repo
RUN yum install -y openssh-server xterm git mysql mysql-server httpd24-httpd php55w php55w-common php55w-cli mysql mysql-server php55w-devel php55w-mcrypt php55w-mbstring php55w-mysqlnd php55w-pdo php55w-pecl-xdebug php55w-xml php55w-xmlrpc php55w-opcache php55w-gd

# setup sshd
RUN mkdir -p /var/run/sshd ; chmod -rx /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# config mysql
RUN echo "NETWORKING=yes" > /etc/sysconfig/network
RUN sed -i "s/^bind-address/#bind-address/" /etc/my.cnf
RUN ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock
RUN /sbin/service mysqld start; /usr/bin/mysqladmin -u root password "123456"; /usr/bin/mysql -uroot -p123456 -e "CREATE DATABASE dev; CREATE USER 'dev'@'localhost' IDENTIFIED BY '123456'; GRANT ALL PRIVILEGES ON dev.* TO 'dev'@'localhost'; FLUSH PRIVILEGES;"

# config apache
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
RUN sed -i 's/#LoadModule rewrite_module modules\/mod_rewrite.so/LoadModule rewrite_module modules\/mod_rewrite.so/' /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf

# enable EPEL repository
RUN yum install -y --nogpgcheck http://dl.iuscommunity.org/pub/ius/stable/Redhat/6/x86_64/epel-release-6-5.noarch.rpm

# install supervisord
RUN yum install -y --nogpgcheck supervisor

# settings
ADD supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor

EXPOSE 22 80 3306
CMD ["/usr/bin/supervisord"]