#!/bin/bash

load_config()
{
        source config
}

checking_files_and_permissions()
{

	[ -x $SF_PATH/speedflow ] && echo "speedflow ok" || echo "speedflow do not have the right permissions"
	[ -x $SF_PATH/sfSchedule ] && echo "sfSchedule ok" || echo "sfSchedule do not have the right permissions"
	[ -x $SF_PATH/pbiRestApi ] && echo "pbiRestApi ok" || echo "pbiRestApi do not have the right permissions"
	[ -r $SF_PATH/config ] && echo "config ok" || echo "config do not have the right permissions"

}




copy_files()
{

	cp ./* $SF_PATH/
	chown $SF_USER:$SFUSER $SF_PATH
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

	if [ $USER == speedflow ] && [ $GROUP == speedflow ]]; then
		echo "User and group OK"
	else
		echo "Creating user and group ...."
		useradd $SF_USER
		USER=$(cat /etc/passwd | grep speedflow | cut -d: -f1)
		GROUP=$(cat /etc/group | grep speedflow | cut -d: -f1)
		if [ $USER == speedflow ] && [ $GROUP == speedflow ]]; then
			echo "User and group OK"	
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


load_config
start_installer
users_and_groups_check
copy_files
checking_files_and_permissions
