#!/bin/bash -e

TF_BUCKET=bamarch-terraform-state-eu-west-1--backups
REGION=eu-west-1
export AWS_PROFILE=personal

# bootstrap a terraform backend
aws s3api create-bucket --bucket ${TF_BUCKET} --region ${REGION} --create-bucket-configuration LocationConstraint=${REGION} --acl private
aws s3api put-public-access-block --bucket ${TF_BUCKET} --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
aws s3api put-bucket-encryption --bucket ${TF_BUCKET} --server-side-encryption-configuration '{ "Rules": [{ "ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"} }] }'
aws s3api put-bucket-versioning --bucket ${TF_BUCKET} --versioning-configuration "Status=Enabled"
aws dynamodb create-table --region ${REGION} --attribute-definitions "AttributeName=LockID,AttributeType=S" --key-schema "AttributeName=LockID,KeyType=HASH" --table-name ${TF_BUCKET} --billing-mode PAY_PER_REQUEST

