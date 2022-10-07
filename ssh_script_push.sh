
#!bin/bash
#----------------------------------------------------------#
#                  Variables&Functions                     #
#----------------------------------------------------------#

alert="\033[1;36m"
success="\033[1;32m"
warning="\033[1;33m"
error="\033[1;31m"
nocolour="\033[00m"
user="root"
password="asd123."


if [[ $EUID -ne 0 ]]; then
   echo -e " $error This script must be run as root $nocolour "
   exit 1
fi


echo "$warning powered by $nocolour ";
$success
echo "----    ----   --------   ----------   ----    ---- ";
echo "****   ****   **********  ************ ****    **** ";
echo "----  ----   ----    ---- --        -- ----    ---- ";
echo "*********    ***      *** **        ** ****    **** ";
echo "---------    ---      --- --        -- ----    ---- ";
echo "****  ****   ****    **** **        ** ************ ";
echo "----   ----   ----------  ------------ ------------ ";
echo "****    ****   ********   **********   ************ ";
echo "                                                    ";
$nocolour






#finding the package manager
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        Package_manager=${osInfo[$f]}
        $Package_manager install sshpass fping nmap -y
       
    fi
done

#--------------------------------------------------------------------tested upto here

declare -a host= ("192.168.100.212" "192.168.100.213")
script_path=""

#for client in "${client_machine[@]}"
#do


#sshpass -p "asd123." ssh $user $host

curl --insecure --user $user:$password -T /root/ip.txt  sftp://$host/root/     #working         

#ssh -l $user $host 'bash -s' < $script_path

#done







#sudo apt-get install sshpass
#ssh-keygen and store in Downloads
#ssh-keygen -t rsa -b 4096  -P "" -f "~/Downloads/$user" -q 
#ssh-copy-id -i ~/Downloads/$user.pub $user@localhost -p $password

ssh -l $user $host 'bash -s' < $script_path
