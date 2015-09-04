#!/usr/local/bin/bash

[ -x /sbin/iptables ] || exit 1

declare -i NUM=1

if [ `id -u` != 0 ]
then
	echo -e "\e[1mWarning: \e[31mRequest root user\e[m"
	exit 1
fi

if [ -e ./functions.sh ]
then
	source ./functions.sh
else
	exit 1
fi

############################
# Configure address and port
LAN=192.168.1.1
HOST=127.0.0.1
HOME=192.168.1.254
LOCAL=192.168.1.0/24

##############
# Find a rules
if [ "${1}" = "help" ]
then
	echo -e "Usage: ./init.sh .. [cmd]\n"
fi

if [ "${1}" = "save" ]
then
	if [ -x /sbin/iptables-save ]
	then
		iptables_find
		sh -c "iptables-save" 1>/dev/null
		[ ${?} = 0 ] && echo -e "\e[1mNOTICE: \e[33mSave iptables\e[m"
	else
		exit 1
	fi
else
	export COLOR=true
	iptables_find
fi

exit 0

