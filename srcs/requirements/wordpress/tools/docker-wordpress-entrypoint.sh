#!/bin/bash

# install wp-cli
mkdir -p /run/php

# download core WordPress files.
if ! wp core is-installed --allow-root >> /dev/null 2>&1; then

    # download core WordPress files.
    wp core download --allow-root

    # generate wp-config.php file
    wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST --allow-root

    # run the standard WordPress installation process
    wp core install --url=$DOMAIN_NAME --title=TEST \
        --admin_user=$WP_ROOT --admin_password=$WP_ROOT_PASSWORD \
        --admin_email=$WP_ROOT_EMAIL --allow-root

    # create wordpress user
    wp user create $WP_USER $WP_EMAIL --user_pass=$WP_PASSWORD \
        --role=author --allow-root

fi

exec "$@"
