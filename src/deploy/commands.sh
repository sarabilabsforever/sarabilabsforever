echo "Creating stack ..."

ID=$(aws cloudformation create-stack --stack-name $STACK_NAME \
--parameters  ParameterKey=Environment,ParameterValue=Development \
--template-body file://someCfScript.yaml \
--capabilities CAPABILITY_AUTO_EXPAND --profile someProfileName| jq -r '.StackId')

aws cloudformation create-stack --stack-name $STACK_NAME \
--parameters  ParameterKey=Environment,ParameterValue=Development \
--template-body file://someCfScript.yaml \
--capabilities CAPABILITY_AUTO_EXPAND --profile someProfileName

aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

aws cloudformation list-stacks \
    --profile Sarabi

aws cloudformation validate-template \
    --template-body file://create-vpc-ec2-v1.yaml \
    --profile Sarabi

aws cloudformation describe-stacks \
    --stack-name create-vpc-ec2-v1 \
    --profile Sarabi

aws cloudformation update-stack --stack-name create-vpc-ec2-v1 \
    --template-body file://create-vpc-ec2-v1.yaml \
    --capabilities CAPABILITY_IAM \
    --profile Sarabi

aws cloudformation create-stack --stack-name create-vpc-ec2-v1 \
    --template-body file://create-vpc-ec2-v1.yaml \
    --capabilities CAPABILITY_IAM \
    --profile Sarabi

aws cloudformation wait stack-create-complete \
    --stack-name create-vpc-ec2-v1 \
    --profile Sarabi

aws cloudformation wait stack-update-complete \
    --stack-name create-vpc-ec2-v1 \
    --profile Sarabi


aws cloudformation delete-stack \
    --stack-name create-vpc-ec2-v1 \
    --profile Sarabi

aws cloudformation create-change-set \
    --stack-name create-vpc-ec2-v1 \
    --change-set-name create-vpc-ec2-v1-change-set \
    --template-body file://create-vpc-ec2-v1.yaml \
    --capabilities CAPABILITY_IAM \
    --profile Sarabi

aws cloudformation create-change-set \
    --stack-name create-vpc-ec2-v1 \
    --change-set-name my-change-set \
    --template-body file://create-vpc-ec2-v1.yaml \
    --capabilities CAPABILITY_IAM \
    --profile Sarabi

aws cloudformation describe-change-set \
    --stack-name create-vpc-ec2-v1 \
    --change-set-name my-change-set \
    --profile Sarabi

aws cloudformation execute-change-set \
    --stack-name create-vpc-ec2-v1 \
    --change-set-name my-change-set \
    --profile Sarabi

aws cloudformation delete-stack \
    --stack-name create-vpc-ec2-v1 \
    --profile Sarabi
