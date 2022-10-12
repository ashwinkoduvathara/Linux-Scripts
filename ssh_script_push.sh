
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


echo -e "$warning powered by $nocolour ";

echo -e "$success----    ----   --------   ----------   ----    ---- $nocolour ";
echo -e "$success****   ****   **********  ************ ****    **** $nocolour ";
echo -e "$success----  ----   ----    ---- --        -- ----    ---- $nocolour";
echo -e "$success*********    ***      *** **        ** ****    **** $nocolour";
echo -e "$success---------    ---      --- --        -- ----    ---- $nocolour";
echo -e "$success****  ****   ****    **** **        ** ************ $nocolour";
echo -e "$success----   ----   ----------  ------------ ------------ $nocolour";
echo -e "$success****    ****   ********   **********   ************ $nocolour";
echo -e "                                                            $nocolour";







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


if [ -z "$ip_addresses" ]; then
   read -p "Please enter the Network_id  : " Network_id
   read -p "Please enter the Broadcast_id  : " Broadcast_id
   mkdir -p /var/MrX
   echo -e "$alert Scanning Network... $nocolour" 
   fping -aqg $Network_id $Broadcast_id > /var/MrX/ip.txt
   host_file=/var/MrX/ip.txt
   if [[ -f "$host_file" ]]; then
     echo -e "$success Network scanned successfully.. $nocolour"
     else
     echo -e " $error Network scan failed $nocolour" 
   fi
   
fi





if [ -z "$key" ]; then
   echo -e "$alert Generating Key.. $nocolour"
   mkdir -p /var/MrX/key
   ssh-keygen -t rsa -b 4096  -P "" -f "/var/MrX/key/Mrx" -q 
   key_file=/var/MrX/key/Mrx
   if [[ -f "$key_file" ]]; then
     echo -e "$success Secret key generated Successfully $nocolour"
     else
     echo -e " $error failed to create key file $nocolour" 
   fi
 
fi



if [ -z "$ssh_key" ]; then
    host_ip=$(cat $host_file )
    for host in $host_ip
    do
    sshpass -p $password ssh -l $user $host 
    done


fi




#
#for host in "{$host_ip[@]}"
# 
# echo $username'@'$host
# 

#  mkdir -p /var/MrX/scripts
   


#--------------------------------------------------------------------tested upto here










# ssh -l $user $host 'bash -s' < $script_path




# #sudo apt-get install sshpass
# #ssh-keygen and store in Downloads
# #ssh-keygen -t rsa -b 4096  -P "" -f "~/Downloads/$user" -q 
# #ssh-copy-id -i ~/Downloads/$user.pub $user@localhost -p $password
# #
# curl --insecure --user root:asd123. -T /root/ip.txt  sftp://192.168.100.213/root/
# ssh -l $user $host 'bash -s' < $script_path
