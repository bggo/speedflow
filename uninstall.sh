#!/bin/bash


check_root()
{
        if [ "$(whoami)" != "root" ]; then
                echo "Script must be run as user: root"
                exit -1
        fi
}

rm_files()
{
	cd /tmp
	rm -r /opt/speedflow/
	rm /etc/sudoers.d/cronflow
	rm /etc/cron.d/flow*
	userdel speedflow
}

check_root
rm_files

