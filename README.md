# 开发基础镜像
包含
* nginx
* php(包含composer phpunit)
* mysql
* redis
* memcached
* nodeJs
* mongodb
* go




#快速使用
```
docker run --rm --name dev -d -p 8888:80 registry.eoffcn.com/dev
```
访问http://localhost:8888




# PHP
### 版本
```
PHP 7.2.4 (cli) (built: Apr  5 2018 01:36:21) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
    with Zend OPcache v7.2.4, Copyright (c) 1999-2018, by Zend Technologies
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






# Nginx
```
/var/www/html # nginx -V
nginx version: nginx/1.13.7
built by gcc 5.3.0 (Alpine 5.3.0) 
built with OpenSSL 1.0.2m  2 Nov 2017
TLS SNI support enabled
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic --with-http_geoip_module=dynamic --with-http_perl_module=dynamic --with-threads --with-stream --with-stream_ssl_module --with-stream_ssl_preread_module --with-stream_realip_module --with-stream_geoip_module=dynamic --with-http_slice_module --with-mail --with-mail_ssl_module --with-compat --with-file-aio --with-http_v2_module --add-module=/usr/src/ngx_devel_kit-0.3.0 --add-module=/usr/src/lua-nginx-module-0.10.11
```
# Nginx Outter Default Conf
cat /etc/nginx/nginx.conf
# Nginx Website Conf
if the default.conf is not good , then you can volume the `/etc/nginx/sites-enabled/default.conf`
# Use
It is not recommended to use SSL. It is not recommended to modify the listen port of the configuration file. It is recommended to directly package the project code to /var/www/html.
# Docker Build
Project document composition
* project files and dir
* Dockerfile

```
FROM lin2798003/anp:latest

COPY . /var/www/html
```

* docker build -t anp-project .

# Docker Run
run the docker cmd
```
$docker run -d -it -p 8089:80 --name project anp-project
```
# Volume Conf Docker Run
```
$docker run -d -it -p 8089:80 -v /tmp/your-conf:/etc/nginx/sites-enabled/default.conf` --name project anp-project
```

# Test
http://127.0.0.1:8089/index.php

## 环境变量:PHP参数相关
* PHP_MEM_LIMIT: php进程内存限制,默认512M
* PHP_POST_MAX_SIZE: php post最大字节 默认100M
* PHP_UPLOAD_MAX_FILESIZE: php最大文件上传限制 默认100M
* FPM_MAX_CHILDREN: php-fpm最大子进程数量
* FPM_SLOWLOG_TIMEOUT: php-fpm慢日志超时时间(单位:秒)

## 特殊环境变量
* APP_NAME: app名称
* APP_PATH: 项目所在目录(默认为:/var/www/html)
* APP_PATH_INDEX: PHP项目index.php入口文件所在目录(默认为:/var/www/html)
* APP_PATH_404: PHP项目404.html文件所在目录(默认为:/var/www/html)
* APP_MONITOR_HOOK: app报警钉钉群机器人webhook
