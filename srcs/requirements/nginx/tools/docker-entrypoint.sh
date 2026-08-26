#!/bin/sh
set -euo pipefail

# Security requirement: Generate a self-signed SSL/TLS certificate if it does not already exist.
# This ensures all web traffic over port 443 is securely encrypted.
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "Generating self-signed SSL certificate for $DOMAIN_NAME..."
    
    mkdir -p /etc/nginx/ssl
    
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=IT/ST=LeHavre/L=LeHavre/O=42/OU=42LeHavre/CN=$DOMAIN_NAME"
        
    echo "SSL certificate generated successfully!"
fi

# Execute the main CMD (which should be "nginx -g 'daemon off;'")
echo "Starting NGINX..."
exec "$@"
