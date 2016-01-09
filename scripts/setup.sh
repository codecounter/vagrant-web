#!/bin/bash

if [ ! -d "/var/down" ]; then
    mkdir /var/down
fi

#####################
# install nginx
#####################

if [ ! -f "/usr/sbin/nginx" ]; then

    # install
    yum install -y nginx

    # add to chkconfig
    chkconfig --add nginx

    # auto start
    chkconfig nginx on

    # overwrite nginx conf
    yes | cp /vagrant/conf/nginx.conf /etc/nginx/nginx.conf

    # create vhosts conf dir
    mkdir /etc/nginx/vhosts

    # default vhost
    cp /vagrant/conf/vhost_default.conf /etc/nginx/vhosts/default.conf

else

    echo "nginx already installed"

fi

#####################
# install php-fpm
#####################

if [ ! -f "/usr/sbin/php-fpm" ]; then

    # install, chkconfig already added
    yum intall -y php-fpm

    # auto start
    chkconfig php-fpm on

else

    echo "php-fpm already installed"

fi

#####################
# install redis
#####################

if [ ! -f "/usr/sbin/redis-server" ]; then

    # install, chkconfig already added
    yum intall -y redis

    # auto start
    chkconfig redis on

    # redis php extension
    git clone https://github.com/phpredis/phpredis /var/down/phpredis
    cd /var/down/phpredis
    phpize
    ./configure
    make && make install
    echo "extension=redis.so" >> /etc/php.ini

else

    echo "redis already installed"

fi

#####################
# install beanstalkd
#####################

if [ ! -f "/usr/bin/beanstalkd" ]; then

    yum install -y beanstalkd

else

    echo "beanstalkd already installed"

fi

#####################
# install nodejs
#####################

if [ ! -f "/usr/bin/node" ]; then

    yum install -y http-parser
    yum install -y libuv
    curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
    yum install -y nodejs
    yum install -y npm

    # npm modules
    npm install bower -g
    npm install grunt -g
    npm install gulp -g

else

    echo "nodejs already installed"

fi

#####################
# install golang
#####################

if [ ! -f "/usr/local/go/bin/go" ]; then

    cd /usr/local
    # wget https://storage.googleapis.com/golang/go1.5.2.linux-amd64.tar.gz
    wget http://files.s0.medlinker.net/install/go1.5.2.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.5.2.linux-amd64.tar.gz
    rm go1.5.2.linux-amd64.tar.gz -f

    echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile
    echo "export GOPATH=/vagrant/go" >> /etc/profile

else

    echo "golang already installed"

fi
