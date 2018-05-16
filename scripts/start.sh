#!/usr/bin/env bash

#nginx
/usr/sbin/nginx

#mysql
/etc/init.d/mysql start

#radis
redis-server &


#rabbitmq
service rabbitmq-service start
#启动web界面 localhost:15672
rabbitmq-plugins enable rabbitmq_management


#mongodb
service mongod start
#配置 /etc/mongod.conf
