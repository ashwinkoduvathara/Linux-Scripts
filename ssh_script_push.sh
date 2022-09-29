
#!bin/bash
#----------------------------------------------------------#
#                  Variables&Functions                     #
#----------------------------------------------------------#

alert="\033[1;36m"
success="\033[1;32m"
warning="\033[1;33m"
error="\033[1;31m"
nocolour="\033[00m"



if [[ $EUID -ne 0 ]]; then
   echo -e " $error This script must be run as root $nocolour "
   exit 1
fi

user="root"
declare -a host= ("192.168.100.212" "192.168.100.213")

script_path=""



for client in "${client_machine[@]}"
do

ssh -l $user $host 'bash -s' < $script_path

done








#ssh-keygen and store in Downloads
#ssh-keygen -t rsa -b 4096  -P "" -f "~/Downloads/$user" -q 
#ssh-copy-id -i ~/Downloads/$user.pub $user@localhost -p $password

ssh -l $user $host 'bash -s' < $script_path

#if [ -z "$port" ]; then
#        read -p 'Please enter  port number (press enter for 8080): ' port
#fi