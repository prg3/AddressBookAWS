#!/bin/bash
apt-get update
apt-get upgrade -y
apt-get install -y puppetmaster nginx git

#Checkout Github
mkdir /git
cd /git
git init
git remote add -f origin https://github.com/prg3/AddressBookAWS.git
git pull origin master
rm -rf /etc/puppet
ln -s /git/puppet /etc/puppet
service puppetmaster restart

#install jenkins
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
apt-get update
apt-get install jenkins -y
apt-get install jenkins -y
mkdir /var/lib/jenkins/addressbook
ln -s /git/jenkins/config.xml /var/lib/jenkins/jobs/addressbook
service jenkins restart
echo "* * * * * root rsync -arv /var/lib/"

#Nginx
ln -sf /git/nginx/master-jenkins /etc/nginx/default
