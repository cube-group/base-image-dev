# 开发基础镜像
基于ubunbu 16.04版本，集成本地开发环常用软件
* php
* nginx
* mysql
* redis
* memcached
* nodeJs
* go
* mongodb
* rabbitmq



# 快速使用DEMO
```
docker run -d \
--name dev \
-p 8888:80 \
-p 3307:3306 \
-p 6379:6379 \
-p 11211:11211 \
-v 开发项目路径:/www/var/html \
-v nginx配置:/etc/nginx/sites-enabled/default
registry.eoffcn.com/dev:stable
```

访问http://localhost:8888或http://127.0.0.1:8888即可访问服务
#### 1.mysql使用
* 1.初始化账号密码均为root
* 2.自动检测项目路径devops/create.sql存在就导入
* 3.连接示例
```
mysql -h127.0.0.1 -P3307 -uroot -proot
```


### 2.nginx使用
* 针对不同的框架路由规则不同，需要自己挂载default.conf覆盖容器/etc/nginx/sites-enabled/default文件

#### 3.redis使用
* 通过127.0.0.1的6379端口访问(无密码)
* php连接示例
```
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);
$redis->lPush("queue", 1, 2, 3, 4, 5);
echo $redis->rPop('queue');
```


#### 4.memcached使用
* 通过127.0.0.1的11211端口访问
* php连接示例代码
```
  $mem = new Memcache;
  $mem->connect('127.0.0.1', 11211);
  $mem->set('key', 'This is a test!', 0, 60);
  echo $mem->get('key');
```


#### 5.rabbitmq使用


#### 6.mongodb使用





# 已安装软件
## PHP
### version
```
PHP 7.2.5-1+ubuntu16.04.1+deb.sury.org+1 (cli) (built: May  5 2018 04:59:13) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
    with Zend OPcache v7.2.5-1+ubuntu16.04.1+deb.sury.org+1, Copyright (c) 1999-2018, by Zend Technologies
    with Xdebug v2.6.0, Copyright (c) 2002-2018, by Derick Rethans
```
### extension
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
memcache
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
zlib

[Zend Modules]
Xdebug
```
### 配置文件
|模式|配置路径|
|---|---|
|cli|/etc/php/7.2/cli/conf.d|
|fpm|/etc/php/7.2/fpm/conf.d|

### php-fpm进程管理
|类型|命令|
|---|---|
|启动|```php-fpm```|
|停止|```kill -INT `cat /run/php/php7.2-fpm.pid` ```|
|重启|```kill -USR2 `cat /run/php/php7.2-fpm.pid` ```|


---



# nginx
### version
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
### nginx管理
|类型|指令|
|---|---|
|启动|nginx|
|停止|nginx -s stop|
|重新载入配置|nginx -s reload|
|检测配置是否正确|nginx -t|

---


# mysql
### version
```
mysql> select version();
+-------------------------+
| version()               |
+-------------------------+
| 5.7.22-0ubuntu0.16.04.1 |
+-------------------------+
1 row in set (0.00 sec)
```
### 账号密码
|账号|密码|
|---|---|
|root|root|

### mysql命令行使用

### 命令行连接示例
```
docker exec -it dev mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 5.7.22-0ubuntu0.16.04.1 (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```
### 配置路径
```
/etc/mysql/conf.d
/etc/mysql/mysql.conf.d/
```
### mysql进程管理
|类型|命令|
|---|---|
|启动|```service mysql start```|
|停止|```servince mysql restart```|
|重启|```servince mysql stop```|


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
### redis-cli使用
```
docker exec -it dev redis-cli
127.0.0.1:6379> keys *
(empty list or set)
127.0.0.1:6379
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
### version
```
root@468696e569db:/etc/redis# node -v
v8.9.3
root@468696e569db:/etc/redis# npm -v
5.5.1
```


--- 

# go
### version
```
root@468696e569db:/etc/redis# go version
go version go1.9 linux/amd64
```


--- 

# mongodb
### version
```
root@9dbe17da8ae2:/# mongo -version
MongoDB shell version v3.4.15
git version: 52e5b5fbaa3a2a5b1a217f5e647b5061817475f9
OpenSSL version: OpenSSL 1.0.2g  1 Mar 2016
allocator: tcmalloc
modules: none
build environment:
    distmod: ubuntu1604
    distarch: x86_64
    target_arch: x86_64
```
默认启动命令
```
mongod --fork --dbpath data --logpath log --logappend
```

--- 


# rabbitmq
默认启动命令
```
rabbitmq-server &
```




# 环境变量 
|环境变量|值说明|
|---|---|
| APP_PATH | 项目路径, 默认/var/www/html |
| APP_PATH_INDEX | 项目首页索引目录(index.php index.html),默认/var/www/html |
| APP_PATH_404 | 404.html存放目录,默认/var/www/html |
| ENABLE_PHP_FPM | 启用fpm，1:启用 0:禁用(默认1) |
| ENABLE_MYSQL | 启用fpm，1:启用 0:禁用(默认1) |
| ENABLE_MEMCACHED | 启用memcached，1:启用 0:禁用(默认1) |
| ENABLE_REDIS | 启用redis，1:启用 0:禁用(默认1) |
| ENABLE_RABBITMQ | 启用rabbitmq，1:启用 0:禁用(默认0) |
| ENABLE_MONGODB | 启用mongodb，1:启用 0:禁用(默认0) |
| MEMCAHED_MEM_SIZE | memcache使用内存大小 默认256MB |
| MEMCACHED_CONNECTION | memcache并发连接数 512 |
| MEMCACHED_PID | memcache启动pid文件 默认/tmp/memcached.pid |







# 其他软件
* git
* composer
* phpunit
* curl
* wget
* ab



