#!/bin/bash

#############
# Set a rules
if [ -d ./rules ]
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

##############
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
	if [ ${COLOR} ]
	then
		/sbin/iptables ${@}
		if [ ${?} = 0 ]
		then
			echo -e "\e[1m${NUM}: \e[33m${@}\e[m"
			NUM=${NUM}+1
		else
			echo -e "\e[1m${NUM}: \e[31m${@}\e[m"
			exit 1
		fi
		return
	else
		/sbin/iptables ${@}
		if [ ${?} != 0 ]
		then
			echo -e "\e[1m${NUM}: \e[31m${@}\e[m"
			exit 1
		fi
		return
	fi
}

