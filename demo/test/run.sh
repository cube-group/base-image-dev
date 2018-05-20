

{
    PASSFILE=$(mktemp -u /var/lib/mysql-files/XXXXXXXXXX)
    install /dev/null -m0600 -omysql -gmysql "$PASSFILE"
    mysql=( mysql --defaults-extra-file="$PASSFILE" --protocol=socket -uroot -hlocalhost --init-command="SET @@SESSION.SQL_LOG_BIN=0;")

    CREATE_SQL=${APP_PATH}/"devops/create.sql"
    if [ -f ${CREATE_SQL} ] ; then
        "${mysql[@]}" < ${CREATE_SQL}
    fi
} &
