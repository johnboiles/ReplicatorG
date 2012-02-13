#!/usr/bin/env python

import tweepy
import optparse

def tweet_with_credentials(tweet, consumerkey, consumersecret, accesskey, accesssecret):
	auth = tweepy.OAuthHandler(consumerkey, consumersecret)
	auth.set_access_token(accesskey, accesssecret)
	api = tweepy.API(auth)
	api.update_status(tweet)

if __name__ == '__main__':
	option_parser = optparse.OptionParser(description='Post a tweet using your auth credentials.')
	option_parser.add_option('--tweet', dest='tweet', help='Twitter status message')
	option_parser.add_option('--consumerkey', dest='consumerkey', help='Consumer Key')
	option_parser.add_option('--consumersecret', dest='consumersecret', help='Consumer Secret')
	option_parser.add_option('--accesskey', dest='accesskey', help='Access Key')
	option_parser.add_option('--accesssecret', dest='accesssecret', help='Access Secret')
	(opts, args) = option_parser.parse_args()

	tweet_with_credentials(opts.tweet, opts.consumerkey, opts.consumersecret, opts.accesskey, opts.accesssecret)
