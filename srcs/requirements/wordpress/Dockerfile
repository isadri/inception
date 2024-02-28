FROM debian:bullseye

LABEL author="isadri"

# change working directory
WORKDIR /var/www/html

EXPOSE 9000

#ENV MYSQL_DATABASE=wp-db \
#	MYSQL_USER=db-user \
#	MYSQL_PASSWORD=123456 \
#	MYSQL_ROOT=root \
#	MYSQL_ROOT_PASSWORD=root123 \
#	MYSQL_HOST=mariadb:3306 \
#	DOMAIN_NAME=isadri.42.fr


# install dependencies
#RUN apt-get update ; apt-get install -y curl php php-curl php-mysqlnd php-intl \
#	php-zip php-fpm iputils-ping

RUN apt-get update ; apt-get install -y curl php7.4-mysql \
	php7.4-fpm iputils-ping

# install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar ; \
	chmod +x wp-cli.phar ; mv wp-cli.phar /usr/local/bin/wp

# wait until mariadb service is started
#HEALTHCHECK --interval=5s --retries=2 \
#			CMD [ "ping", "mariadb" ] || exit 1

# copy php-fpm configuration
COPY tools/www.conf /etc/php/7.4/fpm/pool.d/www.conf
#COPY tools/www.conf .

# copy script to launch
COPY tools/docker-wordpress-entrypoint.sh .

ENTRYPOINT [ "bash", "docker-wordpress-entrypoint.sh" ]

#CMD [ "bash" ]
CMD [ "/usr/sbin/php-fpm7.4", "-F" ]
