FROM debian:12.0

WORKDIR /mydir

RUN apt-get update && apt-get install -y vim && apt-get install -y mariadb-server

COPY script.sh .

RUN chmod +x script.sh && service mariadb start && ./script.sh

#CMD ["mysqld_safe"]