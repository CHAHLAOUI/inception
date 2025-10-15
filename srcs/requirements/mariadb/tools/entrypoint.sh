#!/bin/bash
set -xe

DB_NAME=${MYSQL_DATABASE:-wordpress}
DB_USER=${MYSQL_USER:-wp_user}
DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
DB_USER_PASS=$(cat /run/secrets/db_user_pass)

# تحقق واش قاعدة البيانات مُهيأة (ملفات mysql موجودة)
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Initializing MariaDB database..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

service mariadb start
sleep 5

mysqladmin ping -uroot -p"$DB_ROOT_PASS" --silent
if [ $? -ne 0 ]; then
  echo "MariaDB is not responding"
  exit 1
fi

mysql -uroot << EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASS';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"$DB_ROOT_PASS" shutdown

exec mysqld_safe --bind-address=0.0.0.0
