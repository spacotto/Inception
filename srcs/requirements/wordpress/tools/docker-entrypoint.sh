#!/bin/sh
set -euo pipefail

# Download WP-CLI if it doesn't exist
if [ ! -f /usr/local/bin/wp ]; then
    wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Ensure the working directory exists
mkdir -p /var/www/html
cd /var/www/html

# Check if WordPress is already installed
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Waiting for MariaDB to be ready..."
    while ! mariadb -h mariadb -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE &>/dev/null; do
        sleep 3
    done
    echo "MariaDB is ready!"

    echo "Configuring WordPress..."
    wp config create --dbname=$MYSQL_DATABASE \
                     --dbuser=$MYSQL_USER \
                     --dbpass=$MYSQL_PASSWORD \
                     --dbhost=mariadb \
                     --allow-root
    
    echo "Installing WordPress core..."
    wp core install --url=$DOMAIN_NAME \
                    --title="Inception" \
                    --admin_user=$WP_ADMIN_USER \
                    --admin_password=$WP_ADMIN_PASSWORD \
                    --admin_email=$WP_ADMIN_EMAIL \
                    --allow-root

    echo "Creating the secondary WordPress user..."
    wp user create $WP_USER $WP_USER_EMAIL \
                   --role=author \
                   --user_pass=$WP_USER_PASSWORD \
                   --allow-root

    echo "WordPress initialized successfully!"
else
    echo "WordPress is already configured. Skipping initialization."
fi

# Fix permissions so PHP-FPM can access the files
chown -R nobody:nobody /var/www/html

echo "Starting PHP-FPM..."
exec "$@"
