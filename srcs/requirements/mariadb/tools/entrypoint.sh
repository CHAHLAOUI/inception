#!/bin/sh
set -e

# كلمات السر واليوزر من env
DB_NAME=$MYSQL_DATABASE
DB_USER=$MYSQL_USER
DB_PASS=$(cat $MYSQL_PASSWORD_FILE)
DB_ROOT_PASS=$(cat $MYSQL_ROOT_PASSWORD_FILE)

# إذا مكاينش init, نعمل setup
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
    mysqld_safe --skip-networking &
    sleep 5

    echo "CREATE DATABASE $DB_NAME;" | mysql -u root
    echo "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';" | mysql -u root
    echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';" | mysql -u root
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';" | mysql -u root
    echo "FLUSH PRIVILEGES;" | mysql -u root

    mysqladmin -uroot -p$DB_ROOT_PASS shutdown
    wait
fi

exec "$@"
