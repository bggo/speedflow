#!/bin/bash

load_config()
{
source ./config
}

dep_check()
{
#This is a simple test to check this script dependencies.

if ! [ -x "$(command -v $1)" ]; then
  echo "Error: $1 is not installed. Try apt-get install speedtest." >&2
  exit 1
fi
}

run_speedtest()
{
#Run Speedtest and colect values
speedtest --secure --simple > .collector
if [ $? -eq 0 ]
then
#Parse Results
	PING=$(cat .collector | grep ping -i | cut -d" " -f2)
	DOWN=$(cat .collector | grep down -i | cut -d" " -f2)
	UP=$(cat .collector | grep up -i | cut -d" " -f2)
fi
}

logger()
{
	NOW=$(date -u)
	if [ ! -d "$LOG_DIR" ]; then
		mkdir $LOG_DIR
	fi	
	echo "$NOW - Ping:$PING DOWNLOAD:$DOWN UPLOAD:$UP" >> $LOG_DIR/speedflow.log
}

load_config
dep_check speedtest
run_speedtest
logger
