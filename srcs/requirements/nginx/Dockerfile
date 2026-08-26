FROM alpine:3.23
# Requirement: Build custom images from a bare OS base.
# It is strictly forbidden to pull ready-made application images (e.g., nginx:latest) from DockerHub.

# Install NGINX and OpenSSL (for generating self-signed certificates)
RUN apk update && apk add --no-cache nginx openssl

# Copy the NGINX configuration and entrypoint
COPY conf/nginx.conf /etc/nginx/http.d/default.conf
COPY tools/docker-entrypoint.sh /usr/local/bin/

# Make the entrypoint executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose the HTTPS port
EXPOSE 443

# Start via our initialization script
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]

# The default command passed to the entrypoint (daemon off keeps the container running)
CMD ["nginx", "-g", "daemon off;"]
