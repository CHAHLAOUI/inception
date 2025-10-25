#!/bin/bash
set -e

DB_USER_PASS=$(cat /run/secrets/db_user_pass)
WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_pass)
WP_USER_PASS=$(cat /run/secrets/wp_user_pass)

cd /var/www/html

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";

echo "Debug variables:"
echo "WP_ADMIN_EMAIL = $WP_ADMIN_EMAIL"
echo "MYSQL_DATABASE = $MYSQL_DATABASE"
echo "MYSQL_USER = $MYSQL_USER"
echo "DOMAIN_NAME = $DOMAIN_NAME"
echo "WP_ADMIN_USER = $WP_ADMIN_USER"

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";

if ! command -v wp >/dev/null 2>&1; then
    echo "📦 Installation de WP-CLI..."
    curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

echo "⏳ Attente de MariaDB..."
until mysqladmin ping -h mariadb -u"${MYSQL_USER}" -p"$(cat /run/secrets/db_user_pass)" --silent; do
    echo "⌛ Waiting for MariaDB..."
    sleep 3
done

echo "✅ MariaDB prête !"

if [ ! -f /var/www/html/wp-load.php ]; then
    echo "⚙️ Téléchargement de WordPress..."
    wp core download --allow-root
else
    echo "✅ WordPress déjà présent, pas besoin de le télécharger."
fi

if [ ! -f wp-config.php ]; then
    echo "⚙️ Création du fichier wp-config.php..."
    wp config create --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_USER_PASS}" \
        --dbhost="mariadb:3306"

    echo "⚙️ Installation du site WordPress..."
    wp core install --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}"

    wp user create "${WP_NEW_USER_NAME}" "${WP_NEW_USER_EMAIL}" \
        --role=author --user_pass="${WP_USER_PASS}" --allow-root
else
    echo "✅ WordPress déjà configuré."
fi

echo "🚀 Lancement de PHP-FPM..."

sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf

mkdir -p /run/php

chown www-data:www-data /run/php

exec php-fpm8.2 -F
