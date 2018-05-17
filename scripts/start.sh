#!/usr/bin/env bash


#php-fpm
if [ ! -z "$ENABLE_PHP_FPM" ]; then
    php-fpm
fi




#redis
if [ ! -z "$ENABLE_REDIS" ]; then
    redis-server &
fi


#mysql
if [ ! -z "$ENABLE_MYSQL" ]; then
    service mysql start
fi


#memcached
if [ ! -z "$ENABLE_MEMCACHED" ]; then
    echo 'memcache'
    #TODO memcached
fi


#mongodb
#service mongod start
#service mongodb stop
#mongod --dbpath /mongodb/data/data  --port 27017 --logpath /mongodb/logs --logappend


#rabbitmq
#rabbitmq-server &
#启动web界面 localhost:15672
#rabbitmq-plugins enable rabbitmq_management



#nginx
/usr/sbin/nginx -g "daemon off; error_log /dev/stderr info;"