#!/bin/sh

mkdir -p /run/php

#if ! wp core is-installed 2&gt;/dev/null; then
    # WP is not installed. Let's try installing it.
wp core download --allow-root

wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER \
	--dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST --allow-root

wp core install --url=$DOMAIN_NAME --title=TEST \
	--admin_user=$MYSQL_ROOT --admin_password=$MYSQL_ROOT_PASSWORD \
	--admin_email=isadri@isadri.me --allow-root

wp user create $WP_USER $WP_EMAIL --user_pass=$WP_PASSWORD --allow-root

exec "$@"
