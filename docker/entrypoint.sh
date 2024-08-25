#!/bin/bash

umask 002

# Replace app variables in .env file with their values 
for i in $(cut -s -d= -f1 .env)
do 
        test $(echo \$$i | envsubst) && sed -i "s|$i.*|$i=$(echo \$$i | envsubst)|" .env || true
done

#set -x

# Waiting for Mysql to be available
while [ ${COUNTER:-0} -le 10 ]
do
        timeout 1 mysqladmin ping --host="$DB_HOST" \
                --user="$DB_USERNAME" \
                --password="$DB_PASSWORD" 2>/dev/null \
        && break
        COUNTER=$((COUNTER+1))
        test $COUNTER -ge 10 && { echo "Unable to contact Mysql after 10 tries"; exit 1 ;}
        sleep 9
        echo "Waiting for mysqld to be available..."
done

# Create public storage directory
php artisan storage:link 

# Seed site database on first run and if it is empty
if ! [ -f /app/storage/.initdb ] ; then
        mysqlshow --host="$DB_HOST" \
                --user="$DB_USERNAME" \
                --password="$DB_PASSWORD" $DB_DATABASE favorites 1 >/dev/null 2>&1 || (yes "yes" | php artisan db:seed)
        echo $(date '+%Y%m%d') > /app/storage/.initdb
fi

# Start the php-fpm 
echo "exec php"
test ${NGINX:-1} -eq 0 \
	&& exec php artisan serve --host=0.0.0.0 --port=80 \
	|| exec php-fpm -F --pid /opt/bitnami/php/tmp/php-fpm.pid -y /opt/bitnami/php/etc/php-fpm.conf $@

