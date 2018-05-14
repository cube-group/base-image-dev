FROM lin2798003/anp:latest

MAINTAINER chenqionghe development "chenqionghe@sina.com"

USER root

#install mysql
RUN apk --update add mysql mysql-client && \
        rm -rf /var/cache/apk/* && \
        mysql_install_db && \
        sed -i "s/mysqld\/mysqld.sock/mysqld.sock/" /etc/mysql/my.cnf && \
        rm -rf /var/lib/mysql/ib*

#install redis
RUN apk --update add redis

#install memcached
ENV MEMCACHED_MEMORY 128
ENV MEMCACHED_MAX_CONNECTIONS 1024
ENV MEMCACHED_MAX_ITEM_SIZE 4M
RUN apk --update add memcached && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*



#install mongodb
#RUN apk add --no-cache mongodb && \
#rm /usr/bin/mongoperf

ADD scripts/ /extra

CMD ["sh","/extra/startEnv.sh"]


