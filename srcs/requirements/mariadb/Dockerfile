FROM alpine:3.19

RUN apk update && apk upgrade && apk add --no-cache mariadb mariadb-client

COPY conf/ /etc/my.cnf.d/
COPY tools/ /usr/local/bin/

ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["mysqld"]
