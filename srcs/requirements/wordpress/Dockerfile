FROM alpine:3.19

RUN apk update && apk upgrade && apk add --no-cache \
    php82 php82-fpm php82-mysqli php82-json php82-curl php82-dom \
    php82-exif php82-fileinfo php82-mbstring php82-openssl \
    php82-xml php82-zip php82-phar wget tar curl

COPY conf/ /etc/php82/php-fpm.d/
COPY tools/ /usr/local/bin/

ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["php-fpm82", "-F"]
