#!/bin/bash 
#----------------------------------------------------------#
#                  Variables&Functions                     #
#----------------------------------------------------------#


PASS=""
DATE=$(date +%d-%m-%y)
BACKUP_DIR="/var/mysql_backup"
DB=""



if [[ $EUID -ne 0 ]]; then
   echo -e " This script must be run as root "
   exit 1
fi


if [[ ! -e $BACKUP_DIR ]]; then
    mkdir -p $BACKUP_DIR
fi


mysqldump -u root -p$PASS $DB > $BACKUP_DIR/$DB-$DATE.sql


read -p ' Would you like to backup database regularly [y/n]: ' answer

if [ "$answer" = 'yes' ]; then
    mkdir -p $BACKUP_DIR/script
    touch mysql_backup.sh<EOF
PASS=""
DATE=$(date +%d-%m-%y)
BACKUP_DIR="/var/mysql_backup"
DB=""
mysqldump -u root -p$PASS $DB > $BACKUP_DIR/$DB-$DATE.sql
EOF
crontab -l > mysql_cron
echo "0 10 * * * sudo bash $BACKUP_DIR/script/mysql_backup.sh" >> cron_bkp

fi