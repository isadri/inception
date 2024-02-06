FROM debian:bullseye

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx
RUN apt-get install -y vim && apt-get install -y openssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx_selfsigned.key \
	-out /etc/ssl/certs/nginx_selfsigned.crt    \
	-subj "/C=MO/L=KH/O=1337FIL/OU=IT/CN=iabkadri.42.ma"

EXPOSE 443

COPY config/default.conf /etc/nginx/sites-available/default
