FROM alpine:3.11.3 

COPY ./init.sh .

RUN apk update && apk upgrade
RUN apk -f add nginx wget mariadb-server mysql-client mysql-server wget busybox busybox-extras
RUN apk -f add php7-fpm php7-mbstring php7-session php7-mysqli php7-gettext \
	php7-pdo php7-zip php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc \
	php7-pdo_mysql php7-pdo_sqlite php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib \
	php7-curl php7-ctype php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php-mysql

COPY ./nginx.conf /etc/nginx/conf.d/.
RUN mkdir /run/nginx && touch /run/nginx/nginx.pid && mkdir -p /usr/share/nginx/html

RUN wget -c http://wordpress.org/latest.tar.gz && tar -xzvf latest.tar.gz
RUN mkdir -p /var/www/html/localhost
RUN mv wordpress /var/www/html/localhost

RUN chown -R 777 /var/www/html/localhost
COPY wp-config.php /var/www/html/localhost/wp-config.php

RUN mkdir /root/mkcert
COPY ssl_keys/ca.crt /root/mkcert/ca.crt
COPY ssl_keys/ca.key /root/mkcert/ca.key

EXPOSE 5050

ENTRYPOINT ["sh", "init.sh"]