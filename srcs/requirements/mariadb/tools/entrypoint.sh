#!/bin/bash
set -e

DB_NAME=${MYSQL_DATABASE}
DB_USER=${MYSQL_USER}

echo "---------------------------------------------------------------------------------------------"
echo "$DB_NAME"
echo "$DB_USER"
echo "---------------------------------------------------------------------------------------------"

DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
DB_USER_PASS=$(cat /run/secrets/db_user_pass)

# إعداد MariaDB
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# إنشاء قاعدة البيانات والمستخدم
cat << EOSQL > /usr/local/bin/startup
    CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
    GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

# تشغيل MariaDB كمستخدم mysql
echo " Lancement de MariaDB..."
exec /usr/sbin/mariadbd --user=mysql --init-file=/usr/local/bin/startup --bind-address=0.0.0.0
