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
dir_name="Tools"
Script_path=$(pwd)

dir_profile="/etc/dconf/profile"
dir_locks="/etc/dconf/db/local.d/locks"

cur_hostname=$(cat /etc/hostname)
cur_user=$(echo $SUDO_USER)
gateway="172.16.16.16"
subnet_mask="16"
conn_name="Local_Adapter_1"
dns="1.1.1.1"
# public_ip=$(curl ifconfig.me)
iface=$(ip addr show|grep default|grep -i up|grep -vi loopback|tail -1|awk '{print $2}'|sed 's/:/'/)
current_ip=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
zone="Asia/Kolkata"

Zabbix_server='172.16.16.16'

check_valid_ip() {
    new_ip="$1"
    echo "$new_ip" | egrep -qE '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' || return 1
    echo $new_ip | awk -F'.' '$1 <=255 && $2 <= 255 && $3 <=255 && $4 <= 255 {print "Y" } ' | grep -q Y || return 1
    return 0
}




#----------------------------------------------------------#
#                    Verify Root User                      #
#----------------------------------------------------------#

if [[ $EUID -ne 0 ]]; then
   echo -e "$error This script must be run as root $nocolour"
   exit 1
fi




#----------------------------------------------------------#
#                    Welcome Screen                        #
#----------------------------------------------------------#



echo "Hey, wait for a  seconds..."
sleep 5  
echo "all Done."

echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";


echo -e "$warning                                                    powered by      $nocolour ";

echo -e " $error  ███████╗██╗   ██╗███╗   ██╗███╗   ██╗███████╗███████╗ ██████╗      $nocolour";
echo -e " $error  ██╔════╝╚██╗ ██╔╝████╗  ██║████╗  ██║██╔════╝██╔════╝██╔═══██╗     $nocolour";
echo -e " $error  ███████╗ ╚████╔╝ ██╔██╗ ██║██╔██╗ ██║█████╗  █████╗  ██║   ██║     $nocolour";
echo -e " $error  ╚════██║  ╚██╔╝  ██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══╝  ██║   ██║     $nocolour";
echo -e " $error  ███████║   ██║   ██║ ╚████║██║ ╚████║███████╗██║     ╚██████╔╝     $nocolour";
echo -e " $error  ╚══════╝   ╚═╝   ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝      ╚═════╝      $nocolour";
echo -e " $error                                                              ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";
echo -e "                                                                     ";


# sleep 3
# clear






#----------------------------------------------------------#
#                   Setting up system                      #
#----------------------------------------------------------#

# test from here----
echo -e "$alert Do you want to change the hostname [y/n] $nocolour: " 
read interactive_host

if [ "$interactive_host" = 'y' ]; then
    echo -e "$alert Please enter the hostname $nocolour: " 
    read servername
    hostnamectl set-hostname $servername
    sed -i "s/$cur_hostname/$servername/g" /etc/hosts
    sed -i "s/$cur_hostname/$servername/g" /etc/hostname
    

fi

# echo -e "$alert Do you want to set static ip address [y/n] $nocolour : "
# read interactive_ip

# if [ "$interactive_ip" = 'y' ]; then
#         if [ -z "$new_ip" ]; then
#             echo -e "$alert Please enter the ip address $nocolour: "
#             read new_ip
#             while ! check_valid_ip "$new_ip"
#             do
#                 echo -e "$error Not an valid IP address. Please Re-enter $nocolour: "
#                 read new_ip
#             done
#             nmcli connection add con-name $conn_name ifname $iface type ethernet ipv4.method manual ipv4.addresses $new_ip/$subnet_mask ipv4.gateway $gateway ipv4.dns $dns

#             Network_Adapter_Status=$?            
            
#         fi

#         if [ "$Network_Adapter_Status" -eq "0" ]; then
#             echo -e "$success Network Adapter reset Successfully $nocolour"
#         else
#             echo -e " $error Failed to change IP Address $nocolour "
#         fi
#  fi



timedatectl set-timezone $zone













#----------------------------------------------------------#
#                     block wallpaper                      #
#----------------------------------------------------------#




if [ -d "$dir_profile" ]; then
echo -e "$warning Directory already exists $nocolour "
else
`mkdir -p $dir_profile`;
echo -e " $success $dir_profile directory is created $nocolour "
echo "user-db:user" >>/etc/dconf/profile/user
echo "system-db:local">>/etc/dconf/profile/user

fi


if [ -d "$dir_locks" ]; then
echo -e "$warning Directory already exists $nocolour "
else
`mkdir -p $dir_locks`;
echo -e "$success $dir_locks directory is created $nocolour "
echo "#prevent changes to the wallpaper" >> /etc/dconf/db/local.d/locks/00_wallpaper
echo "/org/cinnamon/desktop/background/picture-uri">>/etc/dconf/db/local.d/locks/00_wallpaper
dconf update

fi

echo -e " $alert Locking  Desktop Settings $nocolour "
chown root:root /home/$cur_user/.config/dconf/user
chmod 040  /home/$cur_user/.config/dconf/user



 # ----- to here




# if [ ! -z "$(grep ^admin: /etc/passwd)" ] ; then
#     echo "Error: user ansible exists"
#     echo
#     echo 'removing ansible user proceeding.'
#     userdel -rf ansible
# fi

# # Check admin group
# if [ ! -z "$(grep ^admin: /etc/group)" ]; then
#     echo "Error: group ansible exists"
#     echo
#     echo 'removing ansible group proceeding.'
#     groupdel -f ansible
# fi







#----------------------------------------------------------#
#                   Setting up packages                    #
#----------------------------------------------------------#

if [ -d "$dir_name" ]; then
echo -e " $error Directory already exists $nocolour "
else
`mkdir -p $dir_name`;
echo -e "$success $dir_name directory is created $nocolour"

fi
cd $dir_name








# Brave Browser
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list












#----------------------------------------------------------#
#                   Package Installation                   #
#----------------------------------------------------------#


echo -e "$alert System Updating Repository $nocolour" 
apt update -y
echo -e "$success Updated Successfully  $nocolour" 

# ----------------------------- ssh

if ! which ssh > /dev/null; then

    echo -e "$alert Installing Openssh  $nocolour" 
    apt install openssh-server openssh-client -y
    echo -e "$success Openssh Installed Successfully  $nocolour" 

    wget http://192.168.100.201/ansible-key.pub


    if [[ -f "ansible-key.pub" ]]; then
        echo -e "$alert Setting Up Public Key  $nocolour "
        mkdir -p ~/.ssh/
        mv ansible-key.pub ~/.ssh/ansible-key.pub
        echo -e "$success public key installed successfully   $nocolour "
    else
        echo -e " $error  failed to fetch Public Key $nocolour "
    fi


fi
# -----------------------------ends here



echo -e "$alert Installing Rustdesk $nocolour" 
wget http://192.168.100.201/rustdesk.deb
apt install ./rustdesk.deb -y
echo -e "$success Anydesk Installed Successfully  $nocolour" 





echo -e "$alert Installing VMware $nocolour" 
wget http://192.168.100.201/workstation.bundle
bash workstation.bundle 
echo -e "$success VMware Installed Successfully  $nocolour" 




echo -e "$alert Installing Cisco Packet Tracer $nocolour" 
wget http://192.168.100.201/cpt.deb 
apt install -y ./cpt.deb
echo -e "$success Cisco Packet Tracer Installed Successfully  $nocolour" 





echo -e "$alert Installing Brave browser $nocolour" 
apt install -y brave-browser
echo -e "$success Cisco Packet Tracer Installed Successfully  $nocolour" 
echo -e " $warning Removing firefox web browser $nocolour" 
apt remove firefox -y
echo -e "$success Removed firefox Successfully  $nocolour" 



#----------------------------------------------------------#
#                   Zabbix configuration                   #
#----------------------------------------------------------#


echo -e "$alert Installing Zabbix Agent $nocolour" 
apt install -y zabbix-agent
sed -i "s/Server=127.0.0.1/Server=$Zabbix_server/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=$Zabbix_server/" /etc/zabbix/zabbix_agentd.conf
# sed -i "s/Hostname=Zabbix/Hostname=$(cat /etc/hostname)/" /etc/zabbix/zabbix_agentd.conf
echo "Hostname=$(cat /etc/hostname)">>/etc/zabbix/zabbix_agentd.conf
echo "ListenPort=10050">>/etc/zabbix/zabbix_agentd.conf



#----------------------------------------------------------#
#                 Firewall configuration                   #
#----------------------------------------------------------#
echo -e "$alert Installing Firewall configuration  $nocolour" 
if [  -f `which firewalld` ] ; then
            apt remove firewalld -y

fi

if [  -f `which ufw` ] ; then
            systemctl disable --now ufw
            # apt install ufw -y
            # systemctl enable --now ufw 
            # ufw allow 10050/tcp
# else
#         ufw allow 10050/tcp
fi



#----------------------------------------------------------#
#                    Block Mass Storage                    #
#----------------------------------------------------------#

ENDTIME=$(date +%s)
echo -e "$success Script executed successfully. Time Elapsed $(($ENDTIME - $STARTTIME)) seconds $nocolour"
echo -e "$success adios amigo $nocolour"
sleep 2

rm -f $Script_path/automation.sh
clear






# sudo adduser --no-create-home --disabled-login --shell /bin/false username