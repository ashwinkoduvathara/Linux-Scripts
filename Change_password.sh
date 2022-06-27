#!/bin/bash


if [ "$EUID" -ne 0 ]
          then echo "Please run as root"
                    exit
fi

echo "Please enter Username:"
read username

echo "Enter the new Password:"
read -s password1

echo "Confirm the Password:"
read -s password2

# Check both passwords match
if [ $password1 != $password2 ]; then
            echo "Passwords do not match"
                 exit
fi



echo -e "$password1\n$password1" | passwd $username                                                                                                                     ~                                                                                                                       ~                                                                                                                       ~                                                          
