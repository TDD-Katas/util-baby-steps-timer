#!/bin/bash

# Absolute path to this script.
SCRIPT=$(readlink -f $0)
# Absolute path this script is in.
SCRIPTPATH=`dirname $SCRIPT`
#echo $SCRIPTPATH

#Check params
if [ $# -lt 2 ];
then
	echo "Syntax is .\take_baby_steps.sh GIT_DIRECTORY RESET_TIME";
	exit 0;
fi
GIT_DIRECTORY=$1
RESET_TIME=$2

watch -n 1 "$SCRIPTPATH/date_test.sh" $GIT_DIRECTORY $RESET_TIME
