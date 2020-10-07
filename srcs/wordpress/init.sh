nginx
php-fpm7
while pgrep nginx > /dev/null && php-fpm7 > /dev/null; do
    sleep 1;
done