#!/bin/bash

load_config()
{
        source config
}

dep_check()
{
#This is a simple test to check this script dependencies.

        if ! [ -x "$(command -v $1)" ]; then
                echo "Error: $1 is not installed. Try apt-get install $1." >&2
                exit 1
        fi

        if ! [ -x "$(command -v $2)" ]; then
                echo "Error: $2 is not installed. Try apt-get install $2." >&2
                exit 1
        fi

}



checking_files_and_permissions()
{

	if [ -x $SF_PATH/speedflow ];then 
		echo "speedflow script - ok"
	else
		echo "speedflow do not have the right permissions - fail"
		exit 1
	fi
	if [ -x $SF_PATH/sfSchedule ];then
		echo "sfSchedule script - ok"
	else
		echo "sfSchedule do not have the right permissions - fail"
		exit 1
	fi
	if [ -x $SF_PATH/pbiRestApi ];then 
		echo "pbiRestApi script - ok"
	else 
		echo "pbiRestApi do not have the right permissions - fail"
		exit 1
	fi
	if [ -r $SF_PATH/config ];then
		echo "config files - ok"
	else
		echo "config do not have the right permissions- fail"
		exit 1
	fi
}




copy_files()
{

	cp -r ./* $SF_PATH/
	chown -R $SF_USER:$SFUSER $SF_PATH
	chmod +x $SF_PATH/speedflow
	chmod +x $SF_PATH/sfSchedule
	chmod +x $SF_PATH/pbiRestApi

}



users_and_groups_check()
{

	#Criando diretórios e usuários
	if [ ! -d "$SF_PATH" ]; then
                mkdir $SF_PATH
        fi

	USER=$(cat /etc/passwd | grep speedflow | cut -d: -f1)
	GROUP=$(cat /etc/group | grep speedflow | cut -d: -f1)

	if [[ $USER == speedflow ]] && [[ $GROUP == speedflow ]]; then
		echo "Checking User and group - OK"
	else
		echo "No user detected, Creating user and group ...."
		useradd $SF_USER
		USER=$(cat /etc/passwd | grep speedflow | cut -d: -f1)
		GROUP=$(cat /etc/group | grep speedflow | cut -d: -f1)
		if [[ $USER == speedflow ]] && [[ $GROUP == speedflow ]]; then
			echo "User and group created - OK"	
		else
			echo "Something went wrong... exiting"
			exit 1
		fi
	fi
	

}


start_installer()
{

	echo "This is a simple script to install speedflow, do you want to proceed? (y/n)"
	shopt -s nocasematch
		read ANSWER
	if [[ $ANSWER == y ]] || [[ $ANSWER == yes ]];then
		echo "Starting .... "
	else
		exit 1
	fi
}

check_root()
{
	if [ "$(whoami)" != "root" ]; then
        	echo "Script must be run as user: root"
        	exit -1
	fi
}

set_cron_config()
{

	echo "Setting cron up"
	cp $SF_PATH/cron/cronflow /etc/sudoers.d/
	chmod 0440 /etc/sudoers.d/cronflow

}


dep_check speedtest curl
check_root
load_config
start_installer
users_and_groups_check
copy_files
set_cron_config
checking_files_and_permissions
