# 开发基础镜像 registry.eoffcn.com/dev:1.0
基于ubunbu 16.04，利用docker快速搭建本地环境,统一开发环境，也避免在装软件上耗费不必要的时间

已安装软件
* php
* nginx
* mysql
* redis
* memcached
* nodeJs
* go
* mongodb
* rabbitmq
* git
* composer
* phpunit
* ab
* curl
* wget


# 1.docker安装
进入网站 http://get.daocloud.io/#install-docker-for-mac-windows  下载适合自己系统的版本
1. Windows10 x64位下载Docher for Windowns
2. Mac OS X 10.10.3以上版下载Docher for Windowns
3. 较旧系统版本过旧选择下载Docker Toolbox

# 2.快速使用

* 绑定host

```
47.95.123.222 registry.eoffcn.com
```

* 登录仓库

账号```inner```，密码```1qaz2wsx3edc```

```
docker login registry.eoffcn.com
```

* 运行容器

```
docker run -d \
--name dev \
-p 8888:80 \
-p 3307:3306 \
-p 6379:6379 \
-p 11211:11211 \
-p 27017:27017 \
-p 5672:5672 \
-p 15672:15672 \
-e USE_MYSQL=1 \
-e USE_FPM=1 \
-e USE_REDIS=1 \
-e USE_MEMCACHED=1 \
-e USE_MONGODB=1 \
-e USE_RABBITMQ=1 \
-v $project:/var/www/html \
-v $nginxConf:/etc/nginx/sites-enabled/default \
registry.eoffcn.com/dev:1.0
```

|参数|说明|
|---|---|
| -v $project:/var/www/html | 将要开发的项目代码挂载到/var/www/html, linux例如：/www/l.eoffcn.com:/var/www/html，windowns例如：D:/l.eoffcn.com:/var/www/html |
| -v $nginxConf:/etc/nginx/sites-enabled/default | 将本机nginx配置文件挂到至容器:/etc/nginx/sitest-enabled/default，linux例如：/www/default.conf, windows例如：D:/www/default.conf |
| -p 8888:80 | 将本机的8888端口映射到容器的80端口，提供nginx服务 |
| -p 3307:3306 | 将本机的3307端口映射到容器的3306端口, 提供mysql服务 |
| -p 6379:6379 | 将本机的6379端口映射到容器的6379端口，提供redis服务 |
| -p 11211:11211 | 将本机的11211端口映射到容器的11211端口，提供memcached服务 |
| -p 27017:27017 | 将本机的27017端口映射到容器的27017端口，提供mongodb服务 |
| -p 5672:5672 | 将本机的5672端口映射到容器的5672端口，提供rabbitmq服务 |
| -p 15672:15672 | 将本机的15672端口映射到容器的15672端口，提供rabbitmq界面服务 |
| -e USE_FPM=1 | 是否启用php-fpm，1:启用 0:禁用，默认1 |
| -e USE_MYSQL=1 | 是否启用mysql，1:启用 0:禁用，默认1 |
| -e USE_MEMCACHED=1 | 是否启用memcached，1:启用 0:禁用，默认0 |
| -e USE_REDIS=1 | 是否启redis，1:启用 0:禁用，默认0 |
| -e USE_MONGODB=1 | 是否启用mongodb，1:启用 0:禁用，默认0 |
| -e USE_RABBITMQ=1 | 是否启用rabbitmq，1:启用 0:禁用，默认0 |


访问 http://localhost:8888 即可

### 2.1 dev镜像使用示例
[https://gitlab.eoffcn.com/ms/demo](https://gitlab.eoffcn.com/ms/demo)


## 2.2 nginx配置
不同的框架路由规则不同，以下列举三种框架的nginx配置

### 2.2.1 orc
```
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	root /var/www/html/public_html;
	index index.php index.html index.htm;
	server_name _;
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
	error_page 404 /404.html;
    location = /404.html {
            root /var/www/errors;
            internal;
    }
	location ~ \.php$ {
        try_files $uri =404;
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php-fpm.sock;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
		fastcgi_index index.php;
		include fastcgi_params;
	}

    location ~* \.(jpg|jpeg|gif|png|css|js|ico|webp|tiff|ttf|svg)$ {
            expires 2d;
    }
	location ~ /\. {
    		log_not_found off;
    		deny all;
	}
}
```

### 2.2.2 thinkphp5

```
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	root /var/www/html/public;
	index index.php index.html index.htm;
	server_name _;

    location / {
        # Redirect everything that isn't a real file to index.php
        # try_files $uri $uri/ /index.php?s=$request_uri;
       if ( !-e $request_filename){
           rewrite ^(.*)$ /index.php?s=/$1 last;
           break;
       }
    }

	error_page 404 /404.html;
    location = /404.html {
            root /var/www/errors;
            internal;
    }
	location ~ \.php$ {
        try_files $uri =404;
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php-fpm.sock;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
		fastcgi_index index.php;
		include fastcgi_params;
	}

    location ~* \.(jpg|jpeg|gif|png|css|js|ico|webp|tiff|ttf|svg)$ {
            expires 2d;
    }
	location ~ /\. {
    		log_not_found off;
    		deny all;
	}
}
```
### 2.2.3 myaf
```
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html/public;
	index index.php index.html index.htm;
	server_name _;
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
	error_page 404 /404.html;
    location = /404.html {
            root /var/www/errors;
            internal;
    }
	location ~ \.php$ {
        try_files $uri =404;
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php-fpm.sock;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
		fastcgi_index index.php;
		include fastcgi_params;
	}
    location ~* \.(jpg|jpeg|gif|png|css|js|ico|webp|tiff|ttf|svg)$ {
            expires 2d;
    }
	location ~ /\. {
    		log_not_found off;
    		deny all;
	}
}
```




## 3.软件说明

### 3.1 mysql
* 初始化账号密码均为```root```
* 自动检测项目目录```./devops/create.sql```存在就导入
* 配置路径
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



### 3.2 php
* 已安装常用扩展

```
mysql
curl
json
mbstring
xml
opcache
gd
mbstring
redis
memcache
memcached
mongodb
Xdebug
yaf
...
```

* 配置文件

|模式|配置路径|
|---|---|
|cli|/etc/php/7.2/cli/conf.d|
|fpm|/etc/php/7.2/fpm/conf.d|

* php-fpm进程管理

|类型|命令|
|---|---|
|启动|```php-fpm```|
|停止|```kill -INT `cat /run/php/php7.2-fpm.pid` ```|
|重启|```kill -USR2 `cat /run/php/php7.2-fpm.pid` ```|



### 3.3 redis
* 环境变量```USE_REDIS```设置为1开启
* 端口：6379 (无密码)
* php连接示例
```
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);
$redis->lPush("queue", 1, 2, 3, 4, 5);
echo $redis->rPop('queue');
```

### 3.4 memcahed
* 环境变量```USE_MEMCACHED```设置为1开启
* 端口：11211
* php连接示例代码
```
  $mem = new Memcache;
  $mem->connect('127.0.0.1', 11211);
  $mem->set('key', 'This is a test!', 0, 60);
  echo $mem->get('key');
```

### 3.5 mongodb
* 环境变量```USE_MONGODB```设置为1开启
* 端口：27017 (无密码)
* php连接示例代码
```
$manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");
// 插入数据
$bulk = new MongoDB\Driver\BulkWrite;
$bulk->insert(['x' => 1, 'name' => 'taobao', 'url' => 'http://www.taobao.com']);
$bulk->insert(['x' => 2, 'name' => 'google', 'url' => 'http://www.google.com']);
$bulk->insert(['x' => 3, 'name' => 'baidu', 'url' => 'http://www.baidu.com']);
$manager->executeBulkWrite('test.sites', $bulk);
```

### 3.6 rabbitmq
* 环境变量```USE_RABBIMQ```设置为1开启
* 端口：5672
* web管理界面：localhost:15672，账号密码均为```admin```



### 3.7 nginx
* 主配置
```
/etc/nginx/nginx.conf
```
* 虚拟主机配置目录
```
/etc/nginx/sites-enabled
```
* nginx管理

|类型|指令|
|---|---|
|启动|nginx|
|停止|nginx -s stop|
|重新载入配置|nginx -s reload|
|检测配置是否正确|nginx -t|


