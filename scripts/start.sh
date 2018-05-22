#!/bin/bash


########################################## php-fpm ##########################################
if [ "$USE_FPM" == "1" ]; then
    /usr/sbin/php-fpm7.2
fi


########################################## redis ##########################################
if [ "$USE_REDIS" == "1" ]; then
    redis-server &
fi


########################################## mysql ##########################################

chown -R mysql:mysql /var/lib/mysql

service mysql start
PASSFILE=$(mktemp -u /var/lib/mysql-files/XXXXXXXXXX)
install /dev/null -m0600 -omysql -gmysql "$PASSFILE"
mysql=( mysql --defaults-extra-file="$PASSFILE" --protocol=socket -uroot -hlocalhost --init-command="SET @@SESSION.SQL_LOG_BIN=0;")

#执行devops/create/sql
{
    CREATE_SQL=${APP_PATH}/"devops/create.sql"
    if [ -f ${CREATE_SQL} ] ; then
        "${mysql[@]}" < ${CREATE_SQL}
    fi
}

"${mysql[@]}" <<-EOSQL
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
flush privileges;
EOSQL
if [ "$USE_MYSQL" == "0" ]; then
    service mysql stop
fi



########################################## mmemcached ##########################################
if [ "$USE_MEMCACHED" == "1"  ]; then
    memcached  -d  -u root -l 127.0.0.1 -p 11211 -m ${MEMCACHE_MEM_SIZE} -c ${MEMCACHED_CONNECTION} -P ${MEMCACHED_PID}
fi


########################################## mongodb ##########################################
if [ "$USE_MONGODB" == "1" ]; then
    mongod --config /etc/mongod.conf &
fi


########################################## rabbitmq ##########################################
if [ "$USE_RABBITMQ" == "1" ]; then
    rabbitmq-server &
    sleep 1 #等待rabbit启动
    rabbitmqctl add_user admin admin
    rabbitmqctl set_user_tags admin administrator
    rabbitmq-plugins enable rabbitmq_management
fi


########################################## nginx 前台运行 ##########################################
if [ ! -z "$APP_PATH_INDEX" ]; then
 sed -i "s#root /var/www/html;#root ${APP_PATH_INDEX};#g" /etc/nginx/sites-enabled/default
fi

if [ ! -z "$APP_PATH_404" ]; then
 sed -i "s#root /var/www/errors;#root ${APP_PATH_404};#g" /etc/nginx/sites-enabled/default
fi

/usr/sbin/nginx -g "daemon off; error_log /dev/stderr info;"