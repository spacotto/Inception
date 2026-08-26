FROM alpine:3.23

# Install PHP-FPM, WordPress dependencies, and MariaDB client (for WP-CLI database checks)
RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-phar \
    wget \
    mariadb-client

# Create a symlink so the 'php' command automatically points to 'php82'
RUN ln -s /usr/bin/php82 /usr/bin/php

# Copy the PHP-FPM configuration and entrypoint
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf
COPY tools/docker-entrypoint.sh /usr/local/bin/

# Make the entrypoint executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose the FastCGI port
EXPOSE 9000

# Start via our initialization script
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]

# The default command passed to the entrypoint (-F forces it to run in the foreground)
CMD ["php-fpm82", "-F"]
