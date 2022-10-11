#!/bin/bash 
PASS=""
DATE=$(date +%d-%m-%y)
BACKUP_DIR="/var/backup"
DB=""
mysqldump -u root -p$PASS $DB > $BACKUP_DIR/$DB-$DATE.sql