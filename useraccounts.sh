if [[ $EUID -ne 0 ]]; then
   echo -e " This script must be run as root "
   exit 1
fi

username=$(cat /tmp/userlist | tr 'A-Z'  'a-z')

for user in $username
do
       useradd $user >> ~/Downloads/user_key.txt
       password=$(</dev/urandom tr -dc A-Za-z0-9 | head -c16)
       echo password of $user is $password >>~/Downloads/user_key.txt
       echo -e "$password\n$password" | passwd $user
       usermod -aG sudo $user
       ssh-keygen -t rsa -b 4096  -P "" -f "~/Downloads/$user" -q 
       ssh-copy-id -i ~/Downloads/$user.pub $user@localhost -p $password

done
