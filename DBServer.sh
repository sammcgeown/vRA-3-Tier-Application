#!/bin/bash
# Install the database
/usr/bin/yum -y install mariadb-server
/usr/bin/systemctl enable mariadb.service
/usr/bin/systemctl start mariadb.service
## Configure the Database
mysql_user_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
# Secure the database installation
/usr/bin/mysqladmin -u root password "$mysql_root_password"
/usr/bin/mysql -u root -p"$mysql_root_password" -e "UPDATE mysql.user SET Password=PASSWORD('$mysql_root_password') WHERE User='root'"
/usr/bin/mysql -u root -p"$mysql_root_password" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
/usr/bin/mysql -u root -p"$mysql_root_password" -e "DELETE FROM mysql.user WHERE User=''"
/usr/bin/mysql -u root -p"$mysql_root_password" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
# Add the app user and database
/usr/bin/mysql -u root -p"$mysql_root_password" -e "CREATE DATABASE $mysql_app_database;"
/usr/bin/mysql -u root -p"$mysql_root_password" -e "GRANT ALL PRIVILEGES ON $mysql_app_database.* TO '$mysql_user_name'@'%' IDENTIFIED BY '$mysql_user_password';"
# Flush privileges
/usr/bin/mysql -u root -p"$mysql_root_password" -e "FLUSH PRIVILEGES"
# Enable remote connections
/usr/bin/echo "bind-address = $mysql_bind_address" >> /etc/my.cnf
# Open MySQL firewall for remote connections
/usr/bin/firewall-cmd --zone=public --add-service=mysql --permanent
/usr/bin/firewall-cmd --reload
/usr/bin/systemctl restart mariadb.service
