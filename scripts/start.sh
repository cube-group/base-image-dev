#!/usr/bin/env bash

source /etc/profile


#php-fpm
#TODO 根据环境变量初始化php-fpm, sed设置内存，上传大小
if [ ! -z "$ENABLE_PHP_FPM" ]; then
    /usr/sbin/php-fpm7.2
fi


#redis
if [ ! -z "$ENABLE_REDIS" ]; then
    redis-server &
fi


#mysql
#TODO my.cnf定制，密码初始化
if [ ! -z "$ENABLE_MYSQL" ]; then
    service mysql start
fi


#memcached
#TODO 根据环境变量，启动memcached
if [ ! -z "$ENABLE_MEMCACHED" ]; then
    memcached  -d -m 1024 -u root -l 127.0.0.1 -p 11211 -c 1024 -P /tmp/memcached.pid
    #TODO memcached
fi


#mongodb
#TODO 初始化密码，根据环境变量memcached

#service mongod start
#service mongodb stop
#mongod --dbpath /mongodb/data/data  --port 27017 --logpath /mongodb/logs --logappend


#rabbitmq
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