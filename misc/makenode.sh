#!/bin/bash

#This is a bit messy, using 2 different aws cli interfaces, will clean it up some other day

INSTANCE=`ec2-run-instances -g sg-804af4e7 --user-data-file start_puppet.sh -t t2.micro -k PuppetServer --region us-west-2 ami-9abea4fb| grep INSTANCE | awk '{print $2}'`
aws elb register-instances-with-load-balancer --load-balancer-name Intuit  --instances $INSTANCE
