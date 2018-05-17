#!/usr/bin/env bash



#php-fpm
php-fpm

#systemctl restart php-fpm7.2 #重启
#systemctl start php-fpm7.2 #启动
#systemctl stop php-fpm7.2 #关闭
#systemctl status php-fpm7.2 #检查状态



#nginx
/usr/sbin/nginx -g "daemon off; error_log /dev/stderr info;"

#mysql
#/etc/init.d/mysql start

#radis
#redis-server &


#rabbitmq
#service rabbitmq-service start
#启动web界面 localhost:15672
#rabbitmq-plugins enable rabbitmq_management


#mongodb
#service mongod start
#配置 /etc/mongod.conf
