#!/bin/bash

declare -i NUM=1

[ -x /sbin/iptables ] || exit 1

#################
# Configure Hosts
# LAN
HOST=192.168.1.0/24
HOME=192.168.1.254
# Server
PPTP_SERVER=192.168.2.0/24
OVPN_SERVER=10.211.1.0/24
# Port
HTTP=80
HTTPS=443
SSH=22
GRE=47
PPTP=1723
# Transparent Port
TOR_PROXY=9040
POLIPO_PROXY=8123

#############
# Set a rules
if [ -d rules ]
then
	typesets_sort () {
		local ORG=${IFS}
		IFS="\N"
		for FILE in $(find ./rules -name "*-*")
		do
			echo ${FILE}
		done
		IFS=${ORG}
		return
	}
	typeset -a FIND_RULE=(`typesets_sort | sort`)
	echo -e "\e[1mLoad Rules: \e[34m${FIND_RULE[@]}\e[m"
else
	echo -e "\e[1mWarning: \e[31mRules direcotry not exists (usage: mkdir rules)\e[m"
	exit 1
fi
# Find a rules
iptables_find () {
	for RULE in ${FIND_RULE[@]}
	do
		if [ ${RULE} ]
		then
			echo -e "\e[1m: \e[32m${RULE}\e[m"
			source ${RULE}
		fi
	done
}
# Color prompt for iptables
iptables () {
	/sbin/iptables ${@}
	[ ${?} = 0 ] && {
		echo -e "\e[1m${NUM}: \e[33m${@}\e[m"
		NUM=${NUM}+1
		return
	} || {
		echo -e "\e[1m${NUM}: \e[31m${@}\e[m"
		exit 1
	}
}
# Check begin root user
if [ `id -u` != 0 ]
then
	echo -e "\e[1mWarning: \e[31mRequest root user (usage: sudo ./init.sh)\e[m"
	exit 1
fi

#############
# Set a rules
# Find a rules
iptables_find
# HTTP, HTTPS (or write rules: 1-http-https)
#iptables -A INPUT -p tcp -m tcp --dport ${HTTP} -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport ${HTTPS} -j ACCEPT
# Log
iptables -A INPUT -j LOG --log-prefix "INPUT_DROP: "
iptables -A INPUT -j DROP

###############
# Save iptables
if [ -x /sbin/iptables ]
then
	if [ "${1}" = "save" ]
	then
		/sbin/iptables 1>/dev/null 2>/dev/null
		echo -e "\n\e[1m\e[32mSave to iptables\e[m"
	fi
fi

exit 0

