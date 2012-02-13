#!/bin/bash

SCRIPT_DIR=$(cd `dirname $0` && pwd)
source "$SCRIPT_DIR"/config.sh

FILE_PATH=$1
FILE_NAME=${FILE_PATH##*/}
ORIGINAL_VIDEO=$FILE_NAME.m4v

sleep 90
osascript "$SCRIPT_DIR"/start_recording.scpt "$ORIGINAL_VIDEO"