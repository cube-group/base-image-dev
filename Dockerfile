FROM ubuntu:16.04

MAINTAINER chenqionghe development "chenqionghe@sina.com"

USER root

#软件开启环境变量
ENV ENABLE_PHP_FPM 1
ENV ENABLE_MYSQL 1
ENV ENABLE_MEMCACHED 1
ENV ENABLE_REDIS 1
ENV ENABLE_RABBITMQ 0
ENV ENABLE_MONGODB 0

#php环境变量
ENV PHP_CLI_CONF_DIR /etc/php/7.2/cli/conf.d
ENV PHP_FPM_CONF_DIR /etc/php/7.2/fpm/conf.d
ENV PHP_EXT_CONF_LINK_DIR /etc/php/7.2/mods-available
ENV PHP_CONF /etc/php/7.2/fpm/php-fpm.conf
ENV FPM_CONF /etc/php/7.2/fpm/pool.d/www.conf
ENV PHP_DEV_INI /etc/php/7.2/cli/conf.d/dev.ini
ENV FPM_MAX_CHILDREN 50
ENV FPM_SLOWLOG /var/log/fpm-slow.log
ENV FPM_SLOWLOG_TIMEOUT 2
ENV FPM_SOCK_FILE /var/run/php-fpm.sock

#nginx环境变量
ENV APP_PATH /var/www/html
ENV APP_PATH_INDEX /var/www/html
ENV APP_PATH_404 /var/www/html


#修改为国内镜像源
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
echo "deb-src http://archive.ubuntu.com/ubuntu xenial main restricted #Added by software-properties" >>/etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted" >>/etc/apt/sources.list && \
echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe #Added by software-properties" >>/etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted" >>/etc/apt/sources.list && \
echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe #Added by software-properties" >>/etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial universe" >>/etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe" >>/etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse" >>/etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse" >>/etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >>/etc/apt/sources.list && \
echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse #Added by software-properties" >>/etc/apt/sources.list && \
echo "deb http://archive.canonical.com/ubuntu xenial partner" >>/etc/apt/sources.list && \
echo "deb-src http://archive.canonical.com/ubuntu xenial partner" >>/etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted" >>/etc/apt/sources.list && \
echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe #Added by software-properties" >>/etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe" >>/etc/apt/sources.list && \
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse" >>/etc/apt/sources.list && \
apt-get update && \
#install tools
apt-get install -y gcc autoconf curl git wget vim libxml2 libxml2-dev libssl-dev bzip2 libbz2-dev libjpeg-dev libpng12-dev \
libfreetype6-dev libgmp-dev libmcrypt-dev libreadline6-dev libsnmp-dev libxslt1-dev libcurl4-openssl-dev apache2-utils


#install php-fpm 7.2
RUN apt-get install -y software-properties-common && \
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
apt-get update && \
apt-get install -y php7.2-fpm && \
#php ext
apt-get install -y php7.2-mysql php7.2-curl php7.2-json php7.2-mbstring php7.2-xml php7.2-opcache php7.2-gd \
php7.2-mongodb php7.2-redis php7.2-memcached php7.2-dev && \
#yaf ext
pecl install yaf && \
#xdebug ext
pecl install xdebug && \
#amqp ext
apt-get install -y librabbitmq-dev && \
pecl install amqp && \
#php-fpm.conf
sed -i "s#;catch_workers_output\s*=\s*yes#catch_workers_output = yes#g" ${FPM_CONF} && \
sed -i "s#pm.max_children = 5#pm.max_children = ${FPM_MAX_CHILDREN}#g" ${FPM_CONF} && \
sed -i "s#pm.start_servers = 2#pm.start_servers = 5#g" ${FPM_CONF} && \
sed -i "s#pm.min_spare_servers = 1#pm.min_spare_servers = 4#g" ${FPM_CONF} && \
sed -i "s#pm.max_spare_servers = 3#pm.max_spare_servers = 6#g" ${FPM_CONF} && \
sed -i "s#;pm.max_requests = 500#pm.max_requests = 200#g" ${FPM_CONF} && \
sed -i "s#;request_slowlog_timeout = 0#request_slowlog_timeout = ${FPM_SLOWLOG_TIMEOUT}#g" ${FPM_CONF} && \
sed -i "s#;listen.mode = 0660#listen.mode = 0666#g" ${FPM_CONF} && \
sed -i "s#;listen.owner = www-data#listen.owner = nginx#g" ${FPM_CONF} && \
sed -i "s#;listen.group = www-data#listen.group = nginx#g" ${FPM_CONF} && \
sed -i "s#listen = /run/php/php7.2-fpm.sock#listen = ${FPM_SOCK_FILE}#g" ${FPM_CONF} && \
sed -i "s#;slowlog = log/\$pool.log.slow#slowlog = ${FPM_SLOWLOG}#g" ${FPM_CONF} && \
mkdir /run/php

#php.ini
COPY ./php-fpm/amqp.ini ${PHP_EXT_CONF_LINK_DIR}/amqp.ini
COPY ./php-fpm/xdebug.ini ${PHP_EXT_CONF_LINK_DIR}/xdebug.ini
COPY ./php-fpm/opcache.ini ${PHP_EXT_CONF_LINK_DIR}/opcache.ini
COPY ./php-fpm/yaf.ini ${PHP_EXT_CONF_LINK_DIR}/yaf.ini
COPY ./php-fpm/dev.ini ${PHP_EXT_CONF_LINK_DIR}/dev.ini
RUN ln -s ${PHP_EXT_CONF_LINK_DIR}/xdebug.ini ${PHP_FPM_CONF_DIR}/xdebug.ini && \
    ln -s ${PHP_EXT_CONF_LINK_DIR}/opcache.ini ${PHP_FPM_CONF_DIR}/opcache.ini && \
    ln -s ${PHP_EXT_CONF_LINK_DIR}/yaf.ini ${PHP_FPM_CONF_DIR}/yaf.ini && \
    ln -s ${PHP_EXT_CONF_LINK_DIR}/amqp.ini ${PHP_FPM_CONF_DIR}/amqp.ini && \
    ln -s ${PHP_EXT_CONF_LINK_DIR}/dev.ini ${PHP_FPM_CONF_DIR}/dev.ini && \
    ln -s ${PHP_EXT_CONF_LINK_DIR}/xdebug.ini ${PHP_CLI_CONF_DIR}/xdebug.ini && \
    ln -s ${PHP_EXT_CONF_LINK_DIR}/opcache.ini ${PHP_CLI_CONF_DIR}/opcache.ini && \
    ln -s ${PHP_EXT_CONF_LINK_DIR}/yaf.ini ${PHP_CLI_CONF_DIR}/yaf.ini && \
    ln -s ${PHP_EXT_CONF_LINK_DIR}/amqp.ini ${PHP_CLI_CONF_DIR}/amqp.ini && \
    ln -s ${PHP_EXT_CONF_LINK_DIR}/dev.ini ${PHP_CLI_CONF_DIR}/dev.ini


#install composer
RUN EXPECTED_COMPOSER_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig) && \
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php -r "if (hash_file('SHA384', 'composer-setup.php') === '${EXPECTED_COMPOSER_SIGNATURE}') { echo 'Composer.phar Installer verified'; } else { echo 'Composer.phar Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
php composer-setup.php --install-dir=/usr/bin --filename=composer && \
php -r "unlink('composer-setup.php');" && \
ln -s /usr/sbin/php-fpm7.2 /usr/local/bin/php-fpm


#install nginx
RUN apt-get install -y nginx
#nginx conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/sites-enabled/default
COPY nginx/404.html ${APP_PATH}
COPY nginx/index.php ${APP_PATH}
COPY nginx/index.html ${APP_PATH}

#install mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server mysql-server mysql-client && \
sed -i "s#bind-address\s*=\s*127.0.0.1#bind-address	= 0.0.0.0#g" /etc/mysql/mysql.conf.d/mysqld.cnf


#install redis
RUN apt-get install -y redis-server

#install memcached
RUN apt-get install -y memcached

#install nodeJs
RUN wget https://nodejs.org/dist/v8.9.3/node-v8.9.3-linux-x64.tar.xz && \
tar -xvf node-v8.9.3-linux-x64.tar.xz && \
mv node-v8.9.3-linux-x64 /usr/local && \
ln -s /usr/local/node-v8.9.3-linux-x64/bin/node /usr/local/bin/node && \
ln -s /usr/local/node-v8.9.3-linux-x64/bin/npm /usr/local/bin/npm && \
rm -f node-v8.9.3-linux-x64.tar.xz

#install golang
RUN curl -O https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz && \
tar -C /usr/local -zxvf go1.9.linux-amd64.tar.gz && \
echo "export GOOROOT=/usr/local/go" >> ./root/.bashrc && \
echo "export PATH=\$PATH:/usr/local/go/bin" >> ./root/.bashrc && \
rm -f go1.9.linux-amd64.tar.gz



#install rabbimq
RUN apt-get install -y rabbitmq-server


#install mongodb
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
apt-get update && \
apt-get install -y mongodb-org


#install phpunit
RUN apt-get install -y phpunit && \
phpunit --version && \
composer config -g repo.packagist composer https://packagist.phpcomposer.com && \
composer global require phpunit/phpunit



#copy scripts
COPY scripts/ /extra


EXPOSE 80
EXPOSE 9000
EXPOSE 3306
EXPOSE 6379
EXPOSE 11211
EXPOSE 27017
EXPOSE 4369 5672 5671 15672 61613 61614 1883 8883

STOPSIGNAL SIGTERM

CMD ["sh","/extra/start.sh"]








