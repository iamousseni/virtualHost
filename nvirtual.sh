#!/bin/bash
set -e #when get some error this script will stopped
echo -e "\e[94m\e[1mIt's a nice name, \e[4m$1\e[0m\e[94m\e[1m! wait some seconds..."
echo -e "\e[94m\e[1mI'm creating the web directory..."
mkdir /var/www/html/$1
echo -e "\e[32m\e[1mOK!"
echo -e "\e[94m\e[1mI'm changing the permission..."
chmod -R 755 /var/www/html/$1
echo -e "\e[32m\e[1mOK!"
echo -e "\e[94m\e[1mI'm creating a sample page for \e[4m$virtualName\e[0m\e[94m\e[1m"
touch /var/www/html/$1/index.php
/bin/cat <<EOM >/var/www/html/$1/index.php
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
          crossorigin="anonymous">

    <title>$1!</title>
</head>
<body>
<p>This is a sample page of <strong>$1</strong> website </p>


<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
        integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
        integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q"
        crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
        integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl"
        crossorigin="anonymous"></script>
</body>
</html>
EOM
echo -e "\e[32m\e[1mOK!"
echo -e "\e[94m\e[1mI'm creating the virtual host..."
FILE=/etc/apache2/sites-available/$1.conf
echo -e "\e[94m\e[1mLoanding\e[5m.......\e[0m\e[94m\e[1m"
touch $FILE
/bin/cat <<EOM >$FILE
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	ServerName $1.test
	ServerAlias www.$1.test
	DocumentRoot /var/www/html/$1

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOM
echo -e "\e[94m\e[1mI'm enabling virtual host configuration files..."
a2ensite $1.conf
echo -e "\e[32m\e[1mOK!"
echo -e "\e[94m\e[1mI'm restarting apache web server to take the effect changes..."
service apache2 restart
echo -e "\e[32m\e[1mOK!"
echo -e "\e[94m\e[1mI'm adding your virtual host on /etc/hosts file..."
/bin/cat <<EOM >>/etc/hosts
127.0.0.1 $1.test
EOM
echo -e "\e[32m\e[1mOK!"
echo -e "\e[32m\e[1mI'm done!"
echo -e "\e[32m\e[1mHappy hacking! ;D"
