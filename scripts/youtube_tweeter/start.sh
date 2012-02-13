#!/bin/bash

FILE_PATH=$1
FILE_NAME=${FILE_PATH##*/}
ORIGINAL_VIDEO=$FILE_NAME.m4v

sleep 90
osascript scripts/start_recording.scpt "$ORIGINAL_VIDEO"