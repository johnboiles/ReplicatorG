#!/bin/bash

SCRIPT_DIR=$(cd `dirname $0` && pwd)
source "$SCRIPT_DIR"/config.sh

FILE_PATH=$1
TIME_ELAPSED=$2
TIME_ELAPSED_STRING=$3

FILE_NAME=${FILE_PATH##*/}
ORIGINAL_VIDEO=$FILE_NAME.m4v

if [ $TIME_ELAPSED -lt $MINIMUM_VIDEO_TIME ]; then
	echo "Build was not long enough to be interesting, aborting video capture."
	osascript "$SCRIPT_DIR"/abort_recording.scpt "$ORIGINAL_VIDEO"
	exit
fi

"$SCRIPT_DIR"/complete.sh $FILE_PATH $TIME_ELAPSED $TIME_ELAPSED_STRING