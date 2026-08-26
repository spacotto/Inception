FROM alpine:3.23
# Requirement: Build custom images from a bare OS base.
# It is strictly forbidden to pull ready-made application images (e.g., mariadb:latest) from DockerHub.
# Install MariaDB
RUN apk update && apk add --no-cache mariadb mariadb-client

# Copy configuration and entrypoint
COPY conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/docker-entrypoint.sh /usr/local/bin/

# Make the entrypoint executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose the standard MariaDB port
EXPOSE 3306

# Start via our initialization script
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]

# The default command passed to the entrypoint

CMD [ "mariadbd-safe", \
"--defaults-file=/etc/my.cnf.d/mariadb-server.cnf" ]