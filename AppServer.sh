#!/bin/bash
# Install Apache and PHP
/usr/bin/yum -y install mysql httpd php php-mysqlnd php-common php-gd php-xml php-mbstring php-mcrypt php-xmlrpc unzip wget
# Download and install Demo app
/usr/bin/wget -O /var/www/html/config.php https://raw.githubusercontent.com/sammcgeown/vRA-3-Tier-Application/master/app/config.php
/usr/bin/wget -O /var/www/html/create.php https://raw.githubusercontent.com/sammcgeown/vRA-3-Tier-Application/master/app/create.php
/usr/bin/wget -O /var/www/html/delete.php https://raw.githubusercontent.com/sammcgeown/vRA-3-Tier-Application/master/app/delete.php
/usr/bin/wget -O /var/www/html/error.php https://raw.githubusercontent.com/sammcgeown/vRA-3-Tier-Application/master/app/error.php
/usr/bin/wget -O /var/www/html/index.php https://raw.githubusercontent.com/sammcgeown/vRA-3-Tier-Application/master/app/index.php
/usr/bin/wget -O /var/www/html/read.php https://raw.githubusercontent.com/sammcgeown/vRA-3-Tier-Application/master/app/read.php
/usr/bin/wget -O /var/www/html/update.php https://raw.githubusercontent.com/sammcgeown/vRA-3-Tier-Application/master/app/update.php
/usr/bin/sed -i "s@DBName@$demo_app_mysql_database@" /var/www/html/config.php
/usr/bin/sed -i "s@DBUser@$demo_app_mysql_user@" /var/www/html/config.php
/usr/bin/sed -i "s@DBPassword@$demo_app_mysql_password@" /var/www/html/config.php
/usr/bin/sed -i "s@DBServer@$demo_app_mysql_server@" /var/www/html/config.php
/usr/bin/sed -i "s@HOSTNAME@$hostname@" /var/www/html/index.php
/usr/bin/wget -O /tmp/employees.sql https://raw.githubusercontent.com/sammcgeown/vRA-3-Tier-Application/master/app/employees.sql
/usr/bin/mysql -u "$demo_app_mysql_user" -p"$demo_app_mysql_password" $demo_app_mysql_database -h $demo_app_mysql_server < /tmp/employees.sql
# Configure and start Apache
/usr/bin/sed -i "/^<Directory \"\/var\/www\/html\">/,/^<\/Directory>/{s/AllowOverride None/AllowOverride All/g}" /etc/httpd/conf/httpd.conf
/usr/bin/sed -i "s@Listen 80@Listen 8080@" /etc/httpd/conf/httpd.conf
/usr/bin/systemctl enable httpd.service
/usr/bin/systemctl start httpd.service
# Open http firewall for remote connections
/usr/bin/firewall-cmd --permanent --zone=public --add-port=8080/tcp
/usr/bin/firewall-cmd --reload
# Configure SELinux to allow remote DB connection
/usr/sbin/setsebool httpd_can_network_connect_db on -P
