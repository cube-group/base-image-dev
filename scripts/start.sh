#!/bin/bash


# Increase the nginx default.conf
if [ ! -z "$APP_PATH_INDEX" ]; then
 sed -i "s#root /var/www/html;#root ${APP_PATH_INDEX};#g" /etc/nginx/sites-enabled/default
fi

# Increase the nginx default.conf
if [ ! -z "$APP_PATH_404" ]; then
 sed -i "s#root /var/www/errors;#root ${APP_PATH_404};#g" /etc/nginx/sites-enabled/default
fi



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



    PASSFILE=$(mktemp -u /var/lib/mysql-files/XXXXXXXXXX)
    install /dev/null -m0600 -omysql -gmysql "$PASSFILE"
    mysql=( mysql --defaults-extra-file="$PASSFILE" --protocol=socket -uroot -hlocalhost --init-command="SET @@SESSION.SQL_LOG_BIN=0;")

    #执行devops/create/sql
    {
        CREATE_SQL=${APP_PATH}/"devops/create.sql"
        if [ -f ${CREATE_SQL} ] ; then
            "${mysql[@]}" < ${CREATE_SQL}
        fi
    } &

    "${mysql[@]}" <<-EOSQL
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
        flush privileges;
EOSQL
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





#nginx 前台运行
/usr/sbin/nginx -g "daemon off; error_log /dev/stderr info;"