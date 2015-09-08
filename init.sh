#!/bin/bash

if [ ! -x /sbin/iptables ]
then
	echo -e "\e[1mERROR: \e\31miptables is not installed\e[m"
	exit 1
fi

if [ $(id -u) != 0 ]
then
	echo -e "\e[1mERROR: \e[31mRequest root user\e[m"
	exit 1
fi

# Configure address and port
LAN=192.168.1.1
HOST=127.0.0.1
HOME=192.168.1.254
LOCAL=192.168.1.0/24

declare -i NUM=1

# Load functions.sh
if [ -e ./functions.sh ]
then
	source ./functions.sh
else
	exit 1
fi

# Find a rules
case "${1}" in
	"save" )
		if [ -x /sbin/ip6tables-save ]
		then
			iptables_find
			sh -c "/sbin/ip6tables-save" 1>/dev/null
			[ ${?} = 0 ] && echo -e "\e[1mNOTICE: \e[33mSave iptables\e[m"
			exit 0
		else
			echo -e "\e[1mERROR: \e[32miptables-save is not installed\e[m"
			exit 1
		fi
	;;
	"debug" )
		exit 0
	;;
	* )
		export COLOR=true
		iptables_find
		exit 0
	;;
esac

exit 1

