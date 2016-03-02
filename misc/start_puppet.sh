#!/bin/bash

set -e -x

# Needed so that the aptitude/apt-get operations will not be interactive
export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get -y upgrade 

# Find the current IP of the puppet master and make "puppet" point to it
puppet_master_ip=$(host puppet.intuit.majestik.org | grep "has address" | head -1 | awk '{print $NF}')
puppet_master_ip=172.31.23.64
echo $puppet_master_ip puppet >> /etc/hosts

aptitude -y install puppet 

# Enable the puppet client
rm /var/lib/puppet/state/agent_disabled.lock

service puppet restart
