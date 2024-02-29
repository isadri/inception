FROM debian:bullseye

LABEL author="isadri"

# set /app as the working directory of the container
WORKDIR /app

EXPOSE 3000

# install dependencies
RUN apt-get update ;\
	apt-get install --no-install-recommends -y mariadb-server

# copy file script
COPY tools/docker-mariadb-entrypoint.sh .

# copy mariadb configuration
COPY tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# create database and user for mariadb
ENTRYPOINT [ "bash", "docker-mariadb-entrypoint.sh"]

CMD [ "mysqld_safe" ]
