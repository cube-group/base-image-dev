#!/usr/bin/env bash

source /etc/profile


#php-fpm
if [ ! -z "$ENABLE_PHP_FPM" ]; then
    /usr/sbin/php-fpm7.2
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
    memcached  -d -m 1024 -u root -l 127.0.0.1 -p 11211 -c 1024 -P /tmp/memcached.pid
fi


#mongodb
if [ ! -z "$ENABLE_MONGODB" ]; then
    mongod --fork --dbpath data --logpath log --logappend
fi



#rabbitmq
if [ ! -z "$ENABLE_RABBITMQ" ]; then
    rabbitmq-server &
fi



#rabbitmq-server &
#启动web界面 localhost:15672
#rabbitmq-plugins enable rabbitmq_management


#nodeJs



#TODO 缩减镜像大小 换成编译安装 ？

#TODO 删除安装包，删除apt-get安装包 RUN合并成一条

#TODO 安装elk


#TODO 提供php-fpm mysql memcached mongodb rabbitmq启动管理的脚本

#TODO 提供mysql工具连接 容器mysql方法

#TODO 提供git初始化默认账号

#TODO 提供XDEBUG开启扩展参数

#TODO 提供挂载目录(php配置、mysql配置、)


#监控脚本，检测目录/devops/create.sql,有就执行导入数据库

#nginx 前台运行
/usr/sbin/nginx -g "daemon off; error_log /dev/stderr info;"