#!/bin/bash
set -e #when get some error this script will stopped
echo -e "\e[94m\e[1mInsert the name of virtual host:"
read -e virtualName
echo -e "\e[94m\e[1mIt's a nice name, \e[4m$virtualName\e[0m\e[94m\e[1m! wait some seconds..."
echo -e "\e[94m\e[1mI'm creating the web directory..."
mkdir /var/www/html/$virtualName
echo -e "\e[32m\e[1mOK!"
echo -e "\e[94m\e[1mI'm changing the permission..."
chmod -R 755 /var/www/html/$virtualName
echo -e "\e[32m\e[1mOK!"
echo -e "\e[94m\e[1mI'm creating a sample page for \e[4m$virtualName\e[0m\e[94m\e[1m"
touch /var/www/html/$virtualName/index.php
/bin/cat <<EOM >/var/www/html/$virtualName/index.php
<html>
 <head>
 <title>$virtualName</title>
 </head>
 <body>
 <p>Hello, This is a test page for <strong>$virtualName</strong> website</p>
 </body>
</html>
EOM
echo -e "\e[32m\e[1mOK!"
echo -e "\e[94m\e[1mI'm creating the virtual host..."
FILE=/etc/apache2/sites-available/$virtualName.conf
echo -e "\e[94m\e[1mLoanding\e[5m.......\e[0m\e[94m\e[1m"
touch $FILE
/bin/cat <<EOM >$FILE
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	ServerName $virtualName.test
	ServerAlias www.$virtualName.test
	DocumentRoot /var/www/html/$virtualName

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOM
echo -e "\e[94m\e[1mI'm enabling virtual host configuration files..."
a2ensite $virtualName.conf
echo -e "\e[32m\e[1mOK!"
echo -e "\e[94m\e[1mI'm restarting apache web server to take the effect changes..."
service apache2 restart
echo -e "\e[32m\e[1mOK!"
echo -e "\e[94m\e[1mI'm adding your virtual host on /etc/hosts file..."
/bin/cat <<EOM >>/etc/hosts
127.0.0.1 $virtualName.test
EOM
echo -e "\e[32m\e[1mOK!"
echo -e "\e[32m\e[1mI'm done!"
echo -e "\e[32m\e[1mHappy hacking! ;D"
