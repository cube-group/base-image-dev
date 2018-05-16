#!/usr/bin/env bash


#php所有扩展
apt-cache search php7.2


systemctl restart php7.2-fpm #重启
systemctl start php7.2-fpm #启动
systemctl stop php7.2-fpm #关闭
systemctl status php7.2-fpm #检查状态