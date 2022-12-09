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

cur_hostname=$(cat /etc/hostname)
servername="synnefo"
gateway="172.16.16.16"
subnet_mask="16"
conn_name="Local Adapter 1"
dns="1.1.1.1"
# public_ip=$(curl ifconfig.me)
iface=$(ip addr show|grep default|grep -i up|grep -vi loopback|tail -1|awk '{print $2}'|sed 's/:/'/)
current_ip=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
zone="Asia/Kolkata"

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








#----------------------------------------------------------#
#                   Setting up system                      #
#----------------------------------------------------------#

hostnamectl set-hostname $servername
sed -i "s/$cur_hostname/$servername/g" /etc/hosts
sed -i "s/$cur_hostname/$servername/g" /etc/hostname
timedatectl set-timezone $zone


# ip address
 if [ -z "$new_ip" ]; then

    read -p "$alert Please enter the ip address $nocolour: " new_ip
    while ! check_valid_ip "$new_ip"
    do
        read -p "$error Not an valid IP address. Please Re-enter $nocolour: " new_ip
    done
    nmcli connection add con-name $conn_name ifname $iface type ethernet ipv4.method manual ipv4.addresses $new_ip/$subnet_mask ipv4.gateway $gateway ipv4.dns $dns

    Network_Adapter_Status=$?            
       
fi

if [ "$Network_Adapter_Status" -eq "0" ]; then
    echo -e "$success Network Adapter reset Successfully $nocolour"
else
    echo -e " $error Failed to change IP Address $nocolour "
fi













#----------------------------------------------------------#
#                   Setting up packages                    #
#----------------------------------------------------------#

if [ -d "$dir_name" ]; then
echo -e " $error Directory already exists $nocolour 
else
`mkdir -p $dir_name`;
echo -e "$success $dir_name directory is created $nocolour

fi



#packettracer
wget https://my.opendesktop.org/s/wDRLrNPPSgjd5ps/download/cpt.deb 
# vmware
wget https://my.opendesktop.org/s/XMrtjLyWp4mw9E6/download/vmware.bundle
vmware=vmware.bundle
# Brave Browser
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list








#----------------------------------------------------------#
#                   Package Installation                   #
#----------------------------------------------------------#


echo -e "$alert System Updating Repository $nocolour" 
apt update -y
echo -e "$success Updated Successfully  $nocolour" 


echo -e "$alert Installing anydesk $nocolour" 
apt install anydesk -y
echo -e "$success Anydesk Installed Successfully  $nocolour" 

echo -e "$alert Installing Teamviewer $nocolour" 
apt install ./tw.deb -y
echo -e "$success Teamviewer Installed Successfully  $nocolour" 


echo -e "$alert Installing VMware $nocolour" 
bash vmware.bundle 
echo -e "$success VMware Installed Successfully  $nocolour" 

echo -e "$alert Installing Cisco Packet Tracer $nocolour" 
apt install -y ./cpt.deb
echo -e "$success Cisco Packet Tracer Installed Successfully  $nocolour" 

echo -e "$alert Installing Brave browser $nocolour" 
apt install -y brave-browser
echo -e "$success Cisco Packet Tracer Installed Successfully  $nocolour" 
echo -e " $warning Removing firefox web browser $nocolour" 
apt remove firefox -y
echo -e "$success Removed firefox Successfully  $nocolour" 








ENDTIME=$(date +%s)
echo -e "$success Script executed successfully. Time Elapsed $(($ENDTIME - $STARTTIME)) seconds $nocolour"
echo -e $success adios amigo $nocolour
sleep 2

rm -f $Script_path/automation.sh
clear
