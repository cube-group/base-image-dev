# 开发基础镜像
包含
* php
* nginx
* mysql
* redis
* memcached
* nodeJs
* go
* mongodb
* rabbitmq




#快速使用
```
docker run -d \
--name dev \
-p 8888:80 \
-p 3307:3306 \
registry.eoffcn.com/dev:stable
```
访问http://localhost:8888




# PHP
### 版本
```
PHP 7.2.5-1+ubuntu16.04.1+deb.sury.org+1 (cli) (built: May  5 2018 04:59:13) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
    with Zend OPcache v7.2.5-1+ubuntu16.04.1+deb.sury.org+1, Copyright (c) 1999-2018, by Zend Technologies
    with Xdebug v2.6.0, Copyright (c) 2002-2018, by Derick Rethans
```
### 支持扩展
```
[PHP Modules]
amqp
calendar
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
hash
iconv
igbinary
json
libxml
mbstring
memcached
mongodb
msgpack
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
Phar
posix
readline
redis
Reflection
session
shmop
SimpleXML
sockets
sodium
SPL
standard
sysvmsg
sysvsem
sysvshm
tokenizer
wddx
xdebug
xml
xmlreader
xmlwriter
xsl
yaf
Zend OPcache
zlib

[Zend Modules]
Xdebug
Zend OPcache
```
### 配置文件路径
cli模式
```
/etc/php/7.2/cli/conf.d
```
fpm模式
```
/etc/php/7.2/fpm/conf.d
```

### php-fpm管理
启动
```
php-fpm
```
重启
```
kill -USR2 `cat /run/php/php7.2-fpm.pid`
```
停止
```
kill -INT `cat /run/php/php7.2-fpm.pid`
```

---



# nginx
### 版本
```
/var/www/html # nginx -V
nginx version: nginx/1.13.7
built by gcc 5.3.0 (Alpine 5.3.0) 
built with OpenSSL 1.0.2m  2 Nov 2017
TLS SNI support enabled
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic --with-http_geoip_module=dynamic --with-http_perl_module=dynamic --with-threads --with-stream --with-stream_ssl_module --with-stream_ssl_preread_module --with-stream_realip_module --with-stream_geoip_module=dynamic --with-http_slice_module --with-mail --with-mail_ssl_module --with-compat --with-file-aio --with-http_v2_module --add-module=/usr/src/ngx_devel_kit-0.3.0 --add-module=/usr/src/lua-nginx-module-0.10.11
```
### 配置
主配置
```
/etc/nginx/nginx.conf
```
虚拟主机配置目录
```
/etc/nginx/sites-enabled
```

---


# mysql
### 版本
```
mysql> select version();
+-------------------------+
| version()               |
+-------------------------+
| 5.7.22-0ubuntu0.16.04.1 |
+-------------------------+
1 row in set (0.00 sec)
```
### 配置路径
```
/etc/mysql/conf.d
/etc/mysql/mysql.conf.d/
```

### mysqld管理
启动
```
service mysql start
```
重启
```
servince mysql restart
```
停止
```
servince mysql stop
```

---

# redis
### 启动
```
redis-server &
```
### 配置路径
```
/etc/redis/redis.conf
```

--- 

# memcached
启动demo
```
memcached  -d -m 1024 -u root -l 127.0.0.1 -p 11211 -c 1024 -P /tmp/memcached.pid
```
停止
```
kill /tmp/memcached.pid
```
参数说明
```
-d 启动为守护进程
-m <num> 分配给Memcached使用的内存数量，单位是MB，默认为64MB
-u <username> 运行Memcached的用户，仅当作为root运行时
-l <ip_addr> 监听的服务器IP地址，默认为环境变量INDRR_ANY的值
-p <num> 设置Memcached监听的端口，最好是1024以上的端口
-c <num> 设置最大并发连接数，默认为1024
-P <file> 设置保存Memcached的pid文件，与-d选择同时使用
```

---

# nodejs
```
root@468696e569db:/etc/redis# node -v
v8.9.3
root@468696e569db:/etc/redis# npm -v
5.5.1
```


--- 

# go
```
root@468696e569db:/etc/redis# go version
go version go1.9 linux/amd64
```


--- 

# mongodb TODO


--- 


# rabbitmq
启动
```
rabbitmq-server &
```










# ENV 环境变量
## PHP参数相关
* PHP_MEM_LIMIT: php进程内存限制,默认512M
* PHP_POST_MAX_SIZE: php post最大字节 默认100M
* PHP_UPLOAD_MAX_FILESIZE: php最大文件上传限制 默认100M
* FPM_MAX_CHILDREN: php-fpm最大子进程数量
* FPM_SLOWLOG_TIMEOUT: php-fpm慢日志超时时间(单位:秒)

## NGINX相关
* APP_PATH: 项目所在目录(默认为:/var/www/html)
* APP_PATH_INDEX: PHP项目index.php入口文件所在目录(默认为:/var/www/html)
* APP_PATH_404: PHP项目404.html文件所在目录(默认为:/var/www/html)





# 其他实用工具
* composer
* phpunit
* ab
