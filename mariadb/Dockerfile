FROM debian:bullseye

WORKDIR /app

RUN apt-get update && apt-get install -y vim && apt-get install -y mariadb-server

COPY script.sh .

RUN bash script.sh

CMD ["mysqld_safe"]
