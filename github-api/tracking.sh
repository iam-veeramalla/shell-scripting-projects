#!/bin/bash

#This Script will report the aws resourse usage

set -x

touch /home/ubuntu/hello.txt

# list S3 bucket list
echo "Print s3 bucket list"
aws s3 ls

# list EC2 instances list
echo "Print EC2 instances list"
aws ec2 describe-instances

#list lambda
echo "Print lambda functions"
aws lambda list-functions

#list IAM users
echo "Print IAM users"
aws iam list-users
