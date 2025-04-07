#!/bin/bash

# Configuration - Update with your details
ROLE_ARN="arn:aws:iam::589276782909:role/deployer" # Replace with your desired role ARN
SESSION_NAME="TerraformSession"  # You can set a custom session name
REGION="ap-southeast-1"  # The region you want to use (e.g., Singapore)

# Step 1: Assume the role using AWS CLI and retrieve temporary credentials
echo "Assuming role $ROLE_ARN..."
ASSUME_ROLE_OUTPUT=$(aws sts assume-role \
  --role-arn "$ROLE_ARN" \
  --role-session-name "$SESSION_NAME" \
  --region "$REGION" \
  --output json)

# Step 2: Extract the temporary credentials (Access Key, Secret Key, Session Token)
AWS_ACCESS_KEY_ID=$(echo $ASSUME_ROLE_OUTPUT | jq -r '.Credentials.AccessKeyId')
AWS_SECRET_ACCESS_KEY=$(echo $ASSUME_ROLE_OUTPUT | jq -r '.Credentials.SecretAccessKey')
AWS_SESSION_TOKEN=$(echo $ASSUME_ROLE_OUTPUT | jq -r '.Credentials.SessionToken')

# Step 3: Export the temporary credentials to environment variables
echo "Setting AWS environment variables..."
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN

