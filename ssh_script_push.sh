
#!bin/bash
#----------------------------------------------------------#
#                  Variables&Functions                     #
#----------------------------------------------------------#

alert="\033[1;36m"
success="\033[1;32m"
warning="\033[1;33m"
error="\033[1;31m"
nocolour="\033[00m"
user="synnefo"
password="asd123."



key_gen(){

      echo -e "$alert Generating Key.. $nocolour"
      mkdir -p /var/MrX/key
      
      ssh-keygen -t rsa -b 4096  -P "" -f "/var/MrX/key/Mrx" -q 
      key_file=/var/MrX/key/Mrx
      if [[ -f "$key_file" ]]; then
        echo -e "$success Secret key generated Successfully $nocolour"
        else
        echo -e " $error failed to create key file $nocolour" 
      fi

  
}



if [[ $EUID -ne 0 ]]; then
   echo -e " $error This script must be run as root $nocolour "
   exit 1
fi


echo "Hey, wait for a  seconds..."
sleep 5  
echo "all Done."

echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";


echo -e "$warning                                         powered by $nocolour ";

echo -e "$success----    ----   --------   ----------   ----    ---- $nocolour";
echo -e "$success****   ****   **********  ************ ****    **** $nocolour";
echo -e "$success----  ----   ----    ---- --        -- ----    ---- $nocolour";
echo -e "$success*********    ***      *** **        ** ****    **** $nocolour";
echo -e "$success---------    ---      --- --        -- ----    ---- $nocolour";
echo -e "$success****  ****   ****    **** **        ** ************ $nocolour";
echo -e "$success----   ----   ----------  ------------ ------------ $nocolour";
echo -e "$success****    ****   ********   **********   ************ $nocolour";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";






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
   #read -p "Please enter the Network_id  : " Network_id
   #read -p "Please enter the Broadcast_id  : " Broadcast_id
   
   mkdir -p /var/MrX
   echo -e "$alert Scanning Network... $nocolour" 
   arp-scan --localnet --quiet --ignoredups | gawk '/([a-f0-9]{2}:){5}[a-f0-9]{2}/ {print $1}'>/var/MrX/ip.txt
   #fping -aqg $Network_id $Broadcast_id > /var/MrX/ip.txt
   sed -i '1d' /var/MrX/ip.txt
   host_file=/var/MrX/ip.txt
   if [[ -f "$host_file" ]]; then
     echo -e "$success Network scanned successfully.. $nocolour"
     else
     echo -e " $error Network scan failed $nocolour" 
   fi
   
fi





if [ -d /var/MrX/key ]; then
  
  echo -e "$alert Key file exist.. $nocolour"
  read -p ' Would you like to create a new key file [y/n]: ' $answer

    if [ "$answer" = 'y' ]; then
       
         key_gen 

    else 

    echo -e  " $success using the existing key file  $nocolour"

    fi


else
     key_gen 
fi



if [ -z "$ssh_key" ]; then
    host_alive=$(cat $host_file )
    for host_ip in $host_alive
    do
    sshpass -p $password ssh-copy-id -i $key_file.pub $user@$host_ip -f
    
    done
    

fi
 echo -e $success adios amigo $nocolour
sleep 2
clear

