#!/bin/sh

# Ensure the mysql directory exists and has correct permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Check if the database has already been initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    
    # Initialize the basic database structures
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Create a temporary SQL script to configure our users and database
    cat << EOF > /tmp/init.sql
USE mysql;
FLUSH PRIVILEGES;

-- Create the database for WordPress
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

-- Create the WordPress user and grant them full rights to the WordPress database
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Update the root password for security
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    # Run the SQL script securely in bootstrap mode (without opening network ports yet)
    mysqld --user=mysql --bootstrap < /tmp/init.sql
    rm -f /tmp/init.sql
    
    echo "MariaDB database initialized successfully."
else
    echo "MariaDB database already exists. Skipping initialization."
fi

# Execute the main command passed from the Dockerfile CMD (which is "mysqld")
echo "Starting MariaDB server..."
exec "$@"
