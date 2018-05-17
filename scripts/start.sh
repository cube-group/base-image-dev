#!/usr/bin/env bash



#php-fpm
php-fpm

#systemctl restart php-fpm7.2 #重启
#systemctl start php-fpm7.2 #启动
#systemctl stop php-fpm7.2 #关闭
#systemctl status php-fpm7.2 #检查状态



#radis
redis-server &


#rabbitmq
#rabbitmq-server &
#启动web界面 localhost:15672
#rabbitmq-plugins enable rabbitmq_management


#mysql
#/etc/init.d/mysql start


#mongodb
#service mongod start
#service mongodb stop
#mongod --dbpath /mongodb/data/data  --port 27017 --logpath /mongodb/logs --logappend




#nginx
/usr/sbin/nginx -g "daemon off; error_log /dev/stderr info;"