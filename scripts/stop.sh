#!/bin/bash
# PWD here is the replicator directory

source scripts/secrets.sh
TMP_VIDEO_DIRECTORY=~/Desktop

FILE_NAME=${FILE_PATH##*/}
ORIGINAL_VIDEO=$FILE_NAME.m4v
PROCESSED_VIDEO=$FILE_NAME-processed.m4v
MINIMUM_VIDEO_TIME=420

FILE_PATH=$1
TIME_ELAPSED=$2
TIME_ELAPSED_STRING=$3

echo $TIME_ELAPSED
echo $TIME_ELAPSED_STRING

if [ $TIME_ELAPSED -lt $MINIMUM_VIDEO_TIME ]; then
	echo "Build was not long enough to be interesting, aborting video capture."
	osascript scripts/abort_recording.scpt "$ORIGINAL_VIDEO"
	exit
fi

echo "Stopping recording"
osascript  scripts/finish_recording.scpt "$ORIGINAL_VIDEO"
sleep 3

echo "Processing video"
ffmpeg -i "$TMP_VIDEO_DIRECTORY/$ORIGINAL_VIDEO" -r 1 -f image2 /tmp/output-%06d.jpg
ffmpeg -r 30 -i /tmp/output-%06d.jpg -sameq -vcodec libx264 -threads 0 -an "$TMP_VIDEO_DIRECTORY/$PROCESSED_VIDEO"
find /tmp/ -name "*.jpg" -exec rm {} \;

echo "Uploading to YouTube"
YOUTUBE_LINK=`youtube-upload --email=$YOUTUBE_EMAIL --password=$YOUTUBE_PASSWORD --title="$FILE_NAME" --category="Tech" --keywords=yelp,makerbot,timelapse --description="Made with Yelp's Makerbot" "$TMP_VIDEO_DIRECTORY/$PROCESSED_VIDEO" --wait-processing`
echo $YOUTUBE_LINK

if [ $YOUTUBE_LINK ]; then
	echo "Removing temporary video files"
	rm "$TMP_VIDEO_DIRECTORY/$ORIGINAL_VIDEO"
	rm "$TMP_VIDEO_DIRECTORY/$PROCESSED_VIDEO"

	TWITTER_STATUS="I just failed to print $FILE_NAME: $YOUTUBE_LINK I am a sad robot."
	echo "Tweeting: $TWITTER_STATUS"
	./scripts/tweeter.py --tweet "$TWITTER_STATUS" --consumerkey $TWITTER_CONSUMER_KEY --consumersecret $TWITTER_CONSUMER_SECRET --accesskey $TWITTER_ACCESS_KEY --accesssecret $TWITTER_ACCESS_SECRET
fi
