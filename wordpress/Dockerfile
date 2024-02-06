FROM debian:bullseye

WORKDIR /var/www/html

RUN apt-get update && apt-get install vim curl unzip iputils-ping -y
RUN apt-get install -y php php-curl php-zip php-mysqlnd php-intl php-fpm
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN wp core download --allow-root

COPY script.sh .

#RUN bash script.sh

CMD ["bash", "script.sh"]
