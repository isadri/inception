# for admin
mysql -e "CREATE DATABASE mydb; CREATE USER 'manager'@localhost; GRANT ALL \
        PRIVILEGES ON *.* TO 'manager'@'localhost'; FLUSH PRIVILEGES;"

# for regular user
mysql -e "CREATE USER 'worker'@localhost; GRANT ALL \
        PRIVILEGES ON mydb.* TO 'worker'@'localhost'; FLUSH PRIVILEGES;"

# mysql_secure_installation

#Enter current password for root (enter for none): <enter>
#Set root password? [Y/n] y
#New password: abc
#Re-enter new password: abc
#Remove anonymous users? [Y/n] y
#Disallow root login remotely? [Y/n] y
#Remove test database and access to it? [Y/n] y
#Reload privilege tables now? [Y/n] y

# make sure that nobody can access the server without a password
mysql -e "UPDATE mysql.user SET Password=PASSWORD('123456') WHERE User='root'"

# kill the anonymous users
mysql -e "DROP USER ''@'localhost'"

# use $(hosntame) because the hostname varies
mysql -e "DROP USER ''@'$(hostname)'"

# kill off the demo database
mysql -e "DROP DATABASE test"

# make our changes take effect
mysql -e "FLUSH PRIVILEGES"
