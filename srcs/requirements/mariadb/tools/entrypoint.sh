# #!/bin/bash
# set -e

# sleep 5


# DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
# DB_USER_PASS=$(cat /run/secrets/db_user_pass)

# mysql -uroot <<-EOSQL
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
# FLUSH PRIVILEGES;

# CREATE DATABASE IF NOT EXISTS ${DB_NAME};
# CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
# GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
# FLUSH PRIVILEGES;
# EOSQL

# # Démarrer MariaDB au premier plan
# exec mysqld_safe --bind-address=0.0.0.0
#!/bin/bash
service mariadb start

# Create database and user
mariadb -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat ${MYSQL_PASSWORD_FILE})';"
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mariadb -e "FLUSH PRIVILEGES;"

mysqladmin shutdown
exec mysqld_safe
