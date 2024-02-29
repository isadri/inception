FROM debian:bullseye

LABEL author="isadri"

# change working directory
WORKDIR /var/www/html

EXPOSE 9000

# install dependencies
RUN apt-get update ; apt-get install -y curl php7.4-mysql \
	php7.4-fpm iputils-ping mariadb-client sendmail

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar ; \
    chmod +x wp-cli.phar ; mv wp-cli.phar /usr/local/bin/wp

# copy php-fpm configuration
COPY tools/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# copy script to launch
COPY tools/docker-wordpress-entrypoint.sh .

ENTRYPOINT [ "bash", "docker-wordpress-entrypoint.sh" ]

CMD [ "/usr/sbin/php-fpm7.4", "-F" ]
