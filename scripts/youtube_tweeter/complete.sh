#!/bin/bash

SCRIPT_DIR=$(cd `dirname $0` && pwd)
source "$SCRIPT_DIR"/config.sh

FILE_PATH=$1
TIME_ELAPSED=$2
TIME_ELAPSED_STRING=$3

FILE_NAME=${FILE_PATH##*/}
ORIGINAL_VIDEO=$FILE_NAME.m4v
PROCESSED_VIDEO=$FILE_NAME-processed.m4v

echo "Stopping recording"
osascript "$SCRIPT_DIR"/finish_recording.scpt "$ORIGINAL_VIDEO"
sleep 3

echo "Processing video"
ffmpeg -i "$TMP_VIDEO_DIRECTORY/$ORIGINAL_VIDEO" -r 1 -f image2 "$TMP_VIDEO_DIRECTORY"/output-%06d.jpg
ffmpeg -r 30 -i "$TMP_VIDEO_DIRECTORY"/output-%06d.jpg -sameq -vcodec libx264 -threads 0 -an "$TMP_VIDEO_DIRECTORY/$PROCESSED_VIDEO"
find "$TMP_VIDEO_DIRECTORY"/ -name "*.jpg" -exec rm {} \;

echo "Uploading to YouTube"
YOUTUBE_DESCRIPTION="Made with Yelp's Makerbot in $TIME_ELAPSED_STRING"
YOUTUBE_KEYWORDS="yelp,makerbot,timelapse"
YOUTUBE_CATEGORY="Tech"
YOUTUBE_UPLOAD_COMMAND="youtube-upload --email=$YOUTUBE_EMAIL --password=$YOUTUBE_PASSWORD --title="$FILE_NAME" --category="$YOUTUBE_CATEGORY" --keywords="$YOUTUBE_KEYWORDS" --description="$YOUTUBE_DESCRIPTION" "$TMP_VIDEO_DIRECTORY/$PROCESSED_VIDEO" --wait-processing"
echo "$YOUTUBE_UPLOAD_COMMAND"
YOUTUBE_LINK=`$YOUTUBE_UPLOAD_COMMAND`
echo $YOUTUBE_LINK

if [ $YOUTUBE_LINK ]; then
	echo "Removing temporary video files"
	rm "$TMP_VIDEO_DIRECTORY/$ORIGINAL_VIDEO"
	rm "$TMP_VIDEO_DIRECTORY/$PROCESSED_VIDEO"

	TWITTER_STATUS="I just printed $FILE_NAME in $TIME_ELAPSED_STRING: $YOUTUBE_LINK"
	echo "Tweeting: $TWITTER_STATUS"
	"$SCRIPT_DIR"/tweeter.py --tweet "$TWITTER_STATUS" --consumerkey $TWITTER_CONSUMER_KEY --consumersecret $TWITTER_CONSUMER_SECRET --accesskey $TWITTER_ACCESS_KEY --accesssecret $TWITTER_ACCESS_SECRET
fi
