#!/bin/bash

set -x

# Set variables
aws_region="us-east-1"
bucket_name="abhishek-ultimate-bucket"
lambda_func_name="s3-lambda-function"
role_name="s3-lambda-sns"
topic_name="s3-lambda-sns"

# Delete SNS subscription (assuming a single subscription)
# subscription_arn=$(aws sns list-subscriptions-by-topic --topic-arn "arn:aws:sns:$aws_region:$(aws sts get-caller-identity --query 'Account' --output text):$topic_name" --query 'Subscriptions[0].SubscriptionArn' --output text)
# aws sns unsubscribe --subscription-arn "$subscription_arn"

# Delete the SNS topic
aws sns delete-topic --topic-arn "arn:aws:sns:$aws_region:$(aws sts get-caller-identity --query 'Account' --output text):$topic_name"

# Remove the Lambda S3 event trigger (if necessary)
# Note: This is typically not required if you're deleting the Lambda function

# Delete the Lambda function
aws lambda delete-function --function-name "$lambda_func_name"

# Empty and delete the S3 bucket
aws s3 rm s3://"$bucket_name" --recursive
aws s3api delete-bucket --bucket "$bucket_name" --region "$aws_region"

# Detach policies from the IAM role
aws iam detach-role-policy --role-name "$role_name" --policy-arn arn:aws:iam::aws:policy/AWSLambda_FullAccess
aws iam detach-role-policy --role-name "$role_name" --policy-arn arn:aws:iam::aws:policy/AmazonSNSFullAccess

# Delete the IAM role
aws iam delete-role --role-name "$role_name"
