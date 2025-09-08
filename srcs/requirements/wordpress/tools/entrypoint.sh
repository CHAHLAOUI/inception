#!/bin/sh
set -e

cd /var/www/html

DB_NAME=$MYSQL_DATABASE
DB_USER=$MYSQL_USER
DB_PASS=$(cat $MYSQL_PASSWORD_FILE)
DB_HOST=mariadb

ADMIN_USER=$WP_ADMIN_USER
ADMIN_PASS=$(cat $WP_ADMIN_PASSWORD_FILE)
ADMIN_EMAIL=$WP_ADMIN_EMAIL

# تثبيت ووردبريس إذا مكاينش
if [ ! -f wp-config.php ]; then
    wp core download --allow-root
    wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$DB_HOST --allow-root
    wp core install --url="https://$DOMAIN_NAME" --title="MySite" \
        --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASS --admin_email=$ADMIN_EMAIL \
        --skip-email --allow-root
fi

# تشغيل php-fpm في foreground mode
php-fpm7.4 -F
