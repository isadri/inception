service mariadb start

# for admin
mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mysql -e "CREATE USER IF NOT EXISTS root_user@'%' IDENTIFIED BY '123456';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root_user'@'%';"
mysql -e "FLUSH PRIVILEGES;"

mysql -e "CREATE USER IF NOT EXISTS dbuser@'%' IDENTIFIED BY '123456';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'dbuser'@'%';"
mysql -e "FLUSH PRIVILEGES;"

echo "port = 3306" >> /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
#echo "bind_address = 0.0.0.0" >> /etc/mysql/mariadb.conf.d/50-server.cnf

#mysqld_safe
bash
