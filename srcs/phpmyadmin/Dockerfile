FROM alpine:3.11.3

COPY ./init.sh .

RUN apk update && apk upgrade
RUN apk -f add nginx mariadb-server php7.3-fpm php-mysql wget 
RUN apk -f add php7-fpm php7-mbstring php7-session php7-mysqli php7-gettext \
	php7-pdo php7-zip php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc \
	php7-pdo_mysql php7-pdo_sqlite php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib \
	php7-curl php7-ctype php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom

RUN mkdir -p /var/www/html/localhost/phpmyadmin

RUN mkdir -p /run/php


RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz && tar -xvzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/localhost/phpmyadmin
COPY ./config.inc.php /var/www/html/localhost/phpmyadmin/

RUN mkdir /run/nginx && touch /run/nginx/nginx.pid && mkdir -p /usr/share/nginx/html
COPY ./default.conf /etc/nginx/conf.d/.
RUN mkdir -p /var/www/html/localhost/phpmyadmin/tmp
RUN chmod ugo+r /var/www/html/localhost/phpmyadmin/tmp
EXPOSE 5000

ENTRYPOINT ["sh", "init.sh"]