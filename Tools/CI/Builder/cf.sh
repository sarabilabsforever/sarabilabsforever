#!/bin/bash
set -e

: "${CLOUDFORMATION_STACK?must be set, e.g CLOUDFORMATION_STACK='Event-Backbone-Dev-Jacob' }"
: "${CLOUDFORMATION_FILE?must be set, e.g CLOUDFORMATION_FILE='CLOUDFORMATION_FILE=./cloudformation/event-backbone/event-backbone.yaml' }"
: ${AWS_DEFAULT_REGION='ap-southeast-2'}
: ${S3_BUCKET='test'}
: ${CHANGESET_NAME="$CLOUDFORMATION_STACK$BUILDKITE_NUMBER"}

# Upload to s3, some files are too big
S3_URI="s3://$S3_BUCKET/$CHANGESET_NAME"
aws s3 cp $CLOUDFORMATION_FILE $S3_URI

# Get the current parameters, otherwise they can default
aws cloudformation describe-stacks --stack-name $CLOUDFORMATION_STACK --query "Stacks[0].Parameters" > parameters.json

# Perform some validation
aws cloudformation validate-template --template-url "http://$S3_BUCKET.s3.amazonaws.com/$CHANGESET_NAME"

# Create a changeset
CHANGESET_ID=$(aws cloudformation create-change-set --stack-name $CLOUDFORMATION_STACK \
    --template-url "http://$S3_BUCKET.s3.amazonaws.com/$CHANGESET_NAME" \
    --parameters file:///`pwd`/parameters.json \
    --output text \
    --change-set-name $CHANGESET_NAME)

# Show the changeset
DESCRIBE=$(aws cloudformation describe-change-set --change-set-name $CHANGESET_NAME --stack-name $CLOUDFORMATION_STACK)
STATUS=$(echo $DESCRIBE | jq -r '.Status')

if [ $STATUS = "FAILED" ]; then
    echo $DESCRIBE | jq -r '.StatusReason'
    exit 1
fi


echo "Applying $CLOUDFORMATION_FILE to $CLOUDFORMATION_STACK"
aws cloudformation execute-change-set --change-set-name $CHANGESET_NAME --stack-name $CLOUDFORMATION_STACK

sleep 5
aws cloudformation wait stack-update-complete --stack-name $CLOUDFORMATION_STACK

# Remove the old change set
aws cloudformation delete-change-set --change-set-name $CHANGESET_NAME --stack-name $CLOUDFORMATION_STACK
aws s3 rm $CLOUDFORMATION_FILE