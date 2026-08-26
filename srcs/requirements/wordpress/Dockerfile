FROM alpine:3.23
# Requirement: Build custom images from a bare OS base.
# It is strictly forbidden to pull ready-made application images (e.g., wordpress:latest) from DockerHub.
# Install PHP-FPM, WordPress dependencies, and MariaDB client (for WP-CLI database checks)
RUN apk update && apk add --no-cache \
    php \
    php-fpm \
    php-mysqli \
    php-json \
    php-curl \
    php-dom \
    php-exif \
    php-fileinfo \
    php-mbstring \
    php-openssl \
    php-xml \
    php-zip \
    php-phar \
    wget \
    mariadb-client

# Create a symlink so the 'php' command automatically points to 'php85'
# RUN ln -s /usr/bin/php85 /usr/bin/php

# Copy the PHP-FPM configuration and entrypoint
COPY conf/www.conf /etc/php84/php-fpm.d/www.conf
COPY tools/docker-entrypoint.sh /usr/local/bin/

# Make the entrypoint executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose the FastCGI port
EXPOSE 9000

# Start via our initialization script
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]

# The default command passed to the entrypoint (-F forces it to run in the foreground)
CMD ["php-fpm84", "-F"]
