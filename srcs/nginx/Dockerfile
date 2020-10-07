FROM alpine:3.11.3

COPY ./init.sh .

RUN apk update && apk upgrade
RUN apk add nginx
RUN apk add bash


RUN mkdir /run/nginx && touch /run/nginx/nginx.pid && mkdir -p /usr/share/nginx/html

COPY ./default.conf /etc/nginx/conf.d/.
COPY index.html /usr/share/nginx/html/.
COPY ssl_keys/ca.crt /etc/ssl/certs/ca.crt
COPY ssl_keys/ca.key /etc/ssl/private/ca.key

EXPOSE 80 443

ENTRYPOINT ["sh", "init.sh"]