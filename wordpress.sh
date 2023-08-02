#!/bin/bash


#----------------------------------------------------------#
#                  Variables&Functions                     #
#----------------------------------------------------------#
alert="\033[1;36m"
success="\033[1;32m"
warning="\033[1;33m"
error="\033[1;31m"
nocolour="\033[00m"
STARTTIME=$(date +%s)



#----------------------------------------------------------#
#                    Verify Root User                      #
#----------------------------------------------------------#

if [[ $EUID -ne 0 ]]; then
   echo -e "$error This script must be run as root $nocolour"
   exit 1
fi



echo -e "$alert Enter your user name : $nocolour "
read username


#----------------------------------------------------------#
#                    Database Creation                     #
#----------------------------------------------------------#

database_exists=$(mysql -u root -p"asd123." -e "show databases like '$username';" | grep -o "$username")


if [ -n "$database_exists" ]; then
  echo -e "$error The database '$username' already exists. Please choose a different domain name or remove the existing database.$nocolour"
  exit 1
fi





mysql -u root -p"asd123." -e "create database $username;"
mysql -u root -p"asd123." -e "create user '${username}_user'@'localhost' identified by '$username';"
mysql -u root -p"asd123." -e "grant all privileges on $username.* to '${username}_user'@'localhost';"



#----------------------------------------------------------#
#                   Wordpress Installation                 #
#----------------------------------------------------------#

# tar -xf /var/www/html/wordpress.tar.gz -C /var/www/html/
unzip -q /var/www/html/latest.zip -d /var/www/html/


mv /var/www/html/wordpress /var/www/html/$username

cp /var/www/html/$username/wp-config-sample.php /var/www/html/$username/wp-config.php


sed -i "s/database_name_here/$username/g" /var/www/html/$username/wp-config.php

sed -i "s/username_here/${username}_user/g" /var/www/html/$username/wp-config.php

sed -i "s/password_here/$username/g" /var/www/html/$username/wp-config.php


chown -R apache:apache /var/www/html/$username
chmod -R 755 /var/www/html/$username




# if [ -e "/etc/httpd/conf.d/${username}.conf" ]; then
#     echo -e "$error File exists at: /etc/httpd/conf.d/${username}.conf $nocolour "
# else
#  cat <<EOF > /etc/httpd/conf.d/${username}.conf
# <VirtualHost *:80>
# ServerName www.${username}.acciva.in
# ServerAlias ${username}.acciva.in
# DocumentRoot /var/www/html/$username       
# </VirtualHost>
# EOF
#     if [ -e "/etc/httpd/conf.d/${username}.conf" ]; then
#         echo -e "$success File created: /etc/httpd/conf.d/${username}.conf $nocolour "
#     fi
# fi


echo -e "$success ======================================= $nocolour "
echo -e "$success ========wordpress credentials========== $nocolour "
echo -e "$success ======================================= $nocolour "
echo -e "$success database is ${username} $nocolour "
echo -e "$success username is ${username}_user $nocolour "
echo -e "$success password is ${username} $nocolour "
echo -e "$success ======================================= $nocolour "
echo -e "$success WordPress installed successfully! $nocolour "
echo -e "$success Your website URL: http://$username $nocolour "
