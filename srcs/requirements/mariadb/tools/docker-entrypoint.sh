#!/bin/sh
set -euo pipefail

# If you prefer to rely solely on the .env variables, comment the variable
# redefinition at the start of the files and uncomment the variables in the
# .env file
MYSQL_DATABASE=$(cat /run/secrets/mysql_database)
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
MYSQL_USER=$(cat /run/secrets/mysql_user)

# First initilization of the database
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[mariadb] Initializing MariaDB database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db > /dev/null

    echo "[mariadb] Creating database and user..."
    cat > /tmp/init.sql <<EOF
        USE mysql;
        FLUSH PRIVILEGES;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOF

    mariadbd --user=mysql --bootstrap < /tmp/init.sql
    rm -f /tmp/init.sql
    echo "[mariadb] Database and user created successfully."
fi

# Execute the main command passed from the Dockerfile CMD (which is "mariadbd-safe")
echo "Starting MariaDB server..."
exec "$@"
