#!/bin/bash


if [ "$EUID" -ne 0 ]
          then echo "Please run as root"
                    exit
fi

STARTTIME=$(date +%s)

dir_name="Tools"
if [ -d "$dir_name" ]; then
echo -e " \e[1;31m Directory already exists \e[0m" #red
else
`mkdir -p $dir_name`;
echo -e "\e[1;32m $dir_name directory is created \e[0m"

fi

cd Tools
echo -e "\e[0;36m Setting up Anydesk repository \e[0m" #cyan
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -
echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list
echo -e "\e[1;32m Added Anydesk repository Successfully  \e[0m" #green

#download packet tracer
echo -e "\e[0;36m Downloading packet tracer \e[0m" #cyan
wget https://my.opendesktop.org/s/wDRLrNPPSgjd5ps/download/cpt.deb 
packet=cpt.deb
if [[ -f "$packet" ]]; then
    echo -e "\e[1;32m packet tracer Download Successfully  \e[0m" #green
else
echo -e " \e[1;31m Not Downloaded \e[0m" #red
fi

#download vmware

echo -e "\e[0;36m Downloading VMware \e[0m" #cyan
wget https://my.opendesktop.org/s/XMrtjLyWp4mw9E6/download/vmware.bundle
vmware=vmware.bundle
if [[ -f "$vmware" ]]; then
    echo -e "\e[1;32m VMware Downloaded Successfully  \e[0m" #green
else
echo -e " \e[1;31m Not Downloaded \e[0m" #red
fi

#download Teamviewer

echo -e "\e[0;36m Downloading Teamviewer \e[0m" #cyan
wget https://my.opendesktop.org/s/5qtdWLHRSasQisy/download/tw.deb
Teamviewer=tw.deb
if [[ -f "$Teamviewer" ]]; then
    echo -e "\e[1;32m Teamviewer Download Successfully  \e[0m" #green
else
echo -e " \e[1;31m Not Downloaded \e[0m" #red
fi


#setting up brave repo
echo -e "\e[0;36m Downloading curl \e[0m" #cyan
apt install apt-transport-https curl
echo -e "\e[1;32m curl Download Successfully  \e[0m" #green

curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

echo -e "\e[0;36m System Updating Repository \e[0m" #cyan
apt update -y
echo -e "\e[1;32m Updated Successfully  \e[0m" #green


echo -e "\e[0;36m Installing anydesk \e[0m" #cyan
apt install anydesk -y
echo -e "\e[1;32m Anydesk Installed Successfully  \e[0m" #green

echo -e "\e[0;36m Installing Teamviewer \e[0m" #cyan
apt install ./tw.deb -y
echo -e "\e[1;32m Teamviewer Installed Successfully  \e[0m" #green


echo -e "\e[0;36m Installing VMware \e[0m" #cyan
bash vmware.bundle 
echo -e "\e[1;32m VMware Installed Successfully  \e[0m" #green

echo -e "\e[0;36m Installing Cisco Packet Tracer \e[0m" #cyan
apt install ./cpt.deb
echo -e "\e[1;32m Cisco Packet Tracer Installed Successfully  \e[0m" #green

echo -e "\e[0;36m Installing Brave browser \e[0m" #cyan
apt install -y brave-browser
echo -e "\e[1;32m Cisco Packet Tracer Installed Successfully  \e[0m" #green
echo -e " \e[1;31m Removing firefox web browser \e[0m" #red
apt remove firefox -y
echo -e "\e[1;32m Removed firefox Successfully  \e[0m" #green
ENDTIME=$(date +%s)
echo -e "\e[1;32m Script executed successfully. Time Elapsed $(($ENDTIME - $STARTTIME)) seconds \e[0m"
