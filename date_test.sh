#!/bin/bash

# Absolute path to this script.
SCRIPT=$(readlink -f $0)
# Absolute path this script is in.
SCRIPTPATH=`dirname $SCRIPT`
#echo $SCRIPTPATH

#Check params
if [ $# -lt 2 ];
then
	$1=.
	$2=120
fi
GIT_DIRECTORY=$1
RESET_TIME=$2

#Create a flag for last revert
REVFLAG_FILENAME=`echo $GIT_DIRECTORY | md5sum | tr -d "-" | tr -d " "` 
REVFLAG_FILEPATH="$SCRIPTPATH/flag_$REVFLAG_FILENAME"
#echo "Flag path is $REVFLAG_FILEPATH"
if [ ! -f $REVFLAG_FILEPATH ]
then
   > $REVFLAG_FILEPATH
fi

#GO to git directory
pushd .  > /dev/null
cd $GIT_DIRECTORY

#Get absolute times
CURRENT_TIME=$(date);
LAST_COMMIT_TIME=$(git show -s --format="%ci" HEAD);
SECS_FOR_CURRENT=$(date --date="$CURRENT_TIME" '+%s')
SECS_FOR_COMMIT=$(date --date="$LAST_COMMIT_TIME" '+%s')
SECS_FOR_REVERT=$(stat --format="%Y" $REVFLAG_FILEPATH)

#Get time since last action
let "SECS_SINCE_COMMIT=$SECS_FOR_CURRENT-$SECS_FOR_COMMIT"
#echo $SECS_SINCE_COMMIT
let "SECS_SINCE_REVERT=$SECS_FOR_CURRENT-$SECS_FOR_REVERT"
#echo $SECS_SINCE_REVERT
if [ $SECS_SINCE_REVERT -lt $SECS_SINCE_COMMIT ]
then
	SECS_SINCE_ACTION=$SECS_SINCE_REVERT
else
	SECS_SINCE_ACTION=$SECS_SINCE_COMMIT
fi

#Test for time elapsed
echo "Time status $SECS_SINCE_ACTION/$RESET_TIME"
if [ $SECS_SINCE_ACTION -gt $RESET_TIME ]
then
	git reset --hard HEAD
	mpg321 -q -g 300 $SCRIPTPATH/aoe_sound.mp3
	> $REVFLAG_FILEPATH
fi

popd .  > /dev/null

