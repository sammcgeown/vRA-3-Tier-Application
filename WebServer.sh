#!/bin/bash
# Add epel-release
/usr/bin/yum -y install epel-release
# Install nginx
/usr/bin/yum -y install nginx
# Download the reverse proxy configuration
/usr/bin/wget -O /etc/nginx/conf.d/proxy.conf https://raw.githubusercontent.com/sammcgeown/vRA-3-Tier-Application/master/config/proxy.nginx.conf
/usr/bin/sed -i "s@SERVERNAME@$web_server_name@" /etc/nginx/conf.d/proxy.conf
/usr/bin/sed -i "s@APPTIER@$app_server_name@" /etc/nginx/conf.d/proxy.conf
# Create the SSL folder
/usr/bin/mkdir /etc/nginx/ssl
# Download the proxy SSL conf
/usr/bin/wget -O /etc/nginx/ssl/proxy.conf https://raw.githubusercontent.com/sammcgeown/vRA-3-Tier-Application/master/config/proxy.ssl.conf
/usr/bin/sed -i "s@WEBSERVERNAME@$web_server_name@" /etc/nginx/ssl/proxy.conf
# Generate SSL keys
/usr/bin/openssl req -x509 -nodes -days 1825 -newkey rsa:2048 -keyout /etc/nginx/ssl/proxy.key -out /etc/nginx/ssl/proxy.pem -config /etc/nginx/ssl/proxy.conf
# Open http firewall for remote connections
/usr/bin/firewall-cmd --permanent --zone=public --add-service=https
/usr/bin/firewall-cmd --reload
# Configure SELinux
/usr/sbin/setsebool -P httpd_can_network_connect true
# Start and enable nginx
/usr/bin/systemctl start nginx
/usr/bin/systemctl enable nginx