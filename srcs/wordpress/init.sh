echo "running .sh"

mysql -h $WORDPRESS_DB_HOST -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD;
while  [ $? == 1 ]; do
	echo "Waiting for mysql to be connected";
	sleep 2;
	mysql -h $WORDPRESS_DB_HOST -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD;
done

mysql -h $WORDPRESS_DB_HOST -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD -se'USE wordpress;'
if [ $? == 1 ]; then
	echo "Database wordpress not found, creating it"
	mysql -h $WORDPRESS_DB_HOST -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD -se'CREATE DATABASE IF NOT EXISTS wordpress;'
	mysql -h $WORDPRESS_DB_HOST -u $WORDPRESS_DB_USER -p $WORDPRESS_DB_PASSWORD wordpress < /wordpress.sql;
	echo "Database created and tables imported"
fi

echo "php-fpm7 launch"
php-fpm7
echo "nginx launch"
nginx -g 'daemon off;'