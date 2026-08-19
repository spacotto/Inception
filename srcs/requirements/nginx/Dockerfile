FROM alpine:3.19

RUN apk update && apk upgrade && apk add --no-cache nginx openssl

COPY conf/ /etc/nginx/http.d/
COPY tools/ /usr/local/bin/

EXPOSE 443
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
