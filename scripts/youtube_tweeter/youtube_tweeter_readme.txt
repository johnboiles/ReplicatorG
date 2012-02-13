# Install youtube-upload
wget http://youtube-upload.googlecode.com/files/youtube-upload-0.7.tgz
tar xvzf youtube-upload-0.7.tgz
cd youtube-upload-0.7
sudo python setup.py install
cd ..
sudo rm -rf youtube-upload-0.7

# Also install pycurl for better uploads
sudo easy_install pycurl

# Install tweepy
sudo easy_install tweepy
sudo easy_install gdata

# Install ant (for building replicatorg)
brew install https://raw.github.com/adamv/homebrew-alt/master/duplicates/ant.rb