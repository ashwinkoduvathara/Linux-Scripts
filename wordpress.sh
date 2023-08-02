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



#----------------------------------------------------------#
#                    Verify Root User                      #
#----------------------------------------------------------#

if [[ $EUID -ne 0 ]]; then
   echo -e "$error This script must be run as root $nocolour"
   exit 1
fi