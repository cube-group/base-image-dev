#!/usr/bin/env bash


#启动nginx
/usr/sbin/nginx

#nginx配置


#所有的配置文件都在/etc/nginx下，并且每个虚拟主机已经安排在了/etc/nginx/sites-available下
#程序文件在/usr/sbin/nginx
#日志放在了/var/log/nginx中
#并已经在/etc/init.d/下创建了启动脚本nginx
#默认的虚拟主机的目录设置在了/var/www/nginx-default

