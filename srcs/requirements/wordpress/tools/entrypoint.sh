#!/bin/bash
set -e

# ===================================================
# 🔐 Lecture des secrets et variables d'environnement
# ===================================================
DB_USER_PASS=$(cat /run/secrets/db_user_pass)
DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
WP_ADMIN_PASS=$(cat /run/secrets/db_user_pass)  

DB_NAME=${MYSQL_DATABASE}
DB_USER=${MYSQL_USER}
DB_HOST="mariadb:3306"

WP_TITLE=${WP_TITLE}
WP_ADMIN_USER=${WP_ADMIN_USER}
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL}
WP_URL=${DOMAIN_NAME}

SITE_PATH="/var/www/site"

# ==============================================
# 🕐 Attendre que MariaDB soit prêt
# ==============================================
echo "⏳ Attente de la disponibilité de la base de données MariaDB..."
until mysqladmin ping -h"${DB_HOST%%:*}" -u"$DB_USER" -p"$DB_USER_PASS" --silent; do
  sleep 2
done
echo "✅ MariaDB est prêt."

# ==============================================
# 📂 Préparer le dossier WordPress
# ==============================================
mkdir -p "$SITE_PATH"
cd "$SITE_PATH"

# ==============================================
# ⚙️ Installer WP-CLI si absent
# ==============================================
if ! command -v wp &> /dev/null; then
  echo "⬇️ Installation de WP-CLI..."
  curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
fi

# ==============================================
# ⚙️ Télécharger et configurer WordPress
# ==============================================
if [ ! -f wp-config.php ]; then
  echo "⬇️ Téléchargement de WordPress..."
  wp core download --allow-root

  echo "⚙️ Configuration du fichier wp-config.php..."
  wp config create --allow-root \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_USER_PASS" \
    --dbhost="$DB_HOST"

  echo "🧱 Installation du site WordPress..."
  wp core install --allow-root \
    --url="/run/secrets/db_root$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL"
else
  echo "✅ WordPress déjà installé, aucune installation nécessaire."
fi

# ==============================================
# 🔧 Configurer PHP-FPM
# ==============================================
sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

# ==============================================
# 🔒 Permissions
# ==============================================
chown -R www-data:www-data "$SITE_PATH"
chmod -R 755 "$SITE_PATH"

# ==============================================
# 🚀 Lancer PHP-FPM
# ==============================================
echo "✅ Lancement du service PHP-FPM..."
exec php-fpm7.4 -F
