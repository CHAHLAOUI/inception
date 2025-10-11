#!/bin/bash
set -e

# متغيرات البيئة
DB_ROOT_PASS=${DB_ROOT_PASS:-root}
DB_NAME=${MYSQL_DATABASE:-wordpress}
DB_USER=${MYSQL_USER:-wp_user}
DB_USER_PASS=${DB_USER_PASS:-wp_pass}

# إنشاء مجلد socket وصلاحياته
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# تشغيل MariaDB في الخلفية لأول مرة
mysqld_safe --skip-networking &

# انتظار أن MariaDB تبدا
echo "⏳ انتظار MariaDB..."
until mysqladmin ping --silent; do
    sleep 2
done
echo "✅ MariaDB جاهزة"

# تهيئة قاعدة البيانات والمستخدمين فقط إذا ما كانوا موجودين
mysql -uroot <<-EOSQL
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
  CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
  CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
  GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
  FLUSH PRIVILEGES;
EOSQL

# قتل السيرفر المؤقت وتشغيل السيرفر الرئيسي foreground
mysqladmin -uroot -p"${DB_ROOT_PASS}" shutdown
echo "🚀 تشغيل MariaDB..."
exec mysqld_safe
