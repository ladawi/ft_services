php-fpm7
nginx
while pgrep nginx > /dev/null && pgrep php-fpm7 > /dev/null; do
    sleep 1;
done