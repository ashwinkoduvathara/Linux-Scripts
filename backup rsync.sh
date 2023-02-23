#!/bin/bash

# Define variables
backup_dir="backup_folder"
remote_ip="172.16.16.16"
remote_username="synnefo"
remote_backup_dir="/tmp"

# Create backup directory if it doesn't exist
if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir"
fi

# Create backup filename using current date and time
backup_file="$backup_dir/backup-$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

# Create backup archive
tar -czvf "$backup_file" /path/to/backup/files

# Copy backup file to remote server using rsync
rsync -avz --progress "$backup_file" "$remote_username@$remote_ip:$remote_backup_dir"

# Remove local backup file
rm "$backup_file"


create a crontab file using crontab -e add this following line  and save it
# 0 3 * * * backup_rsync.sh >/dev/null 2>&1
