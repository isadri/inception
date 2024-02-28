#!/bin/sh

# start mariadb service
service mariadb start

# create a regular mariadb user
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@\`%\` IDENTIFIED BY '${MYSQL_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \`${MYSQL_USER}\`@\`%\`;"
mariadb -e "FLUSH PRIVILEGES;"

# create a mariadb admin
mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_ROOT}\`@\`%\` IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON *.* TO \`${MYSQL_ROOT}\`@\`%\`;"
mariadb -e "FLUSH PRIVILEGES;"

exec "$@"
