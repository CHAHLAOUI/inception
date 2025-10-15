#!/bin/bash
set -e

DB_NAME=${MYSQL_DATABASE:-wordpress}
DB_USER=${MYSQL_USER:-wp_user}
DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
DB_USER_PASS=$(cat /run/secrets/db_user_pass)

# Vérifie si la base de données est déjà initialisée
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "📦 Initialisation du répertoire de données MariaDB..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

  echo "🛠️ Configuration initiale de la base..."
  mysqld_safe --skip-networking &
  sleep 5

  mysql -u root <<-EOSQL
    ALTER USER 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASS}';
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
    GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

  # Arrêter le serveur temporaire
  mysqladmin -u root -p"${DB_ROOT_PASS}" shutdown
else
  echo "✅ Base de données déjà initialisée."
fi

echo "🚀 Lancement de MariaDB..."
exec mysqld_safe --bind-address=0.0.0.0
