wp config create --dbname=$MARIADB_DATABASE --dbuser=$MARIADB_USER --dbpass=$MARIADB_PASSWORD --dbhost=mariadb:3306 --allow-root

wp core install --url=localhost --title="Your Blog Title" --admin_user=root --admin_password=123456 --admin_email=your_email@example.com --allow-root

echo "listen = wordpress:9000" >> /etc/php/7.4/fpm/pool.d/www.conf

#wp user create user user@user.com --role=author --user_pass=123456 --allow-root

mkdir -p /run/php

/usr/sbin/php-fpm7.4 -F