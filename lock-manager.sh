#!/bin/bash

set -e
set -u

# Read AWS profile and region from terraform.tfvars
if [ -r terraform.tfvars ] ; then
    AWS_PROFILE=$(grep -E '^aws_profile\s*=' terraform.tfvars | awk -F'"' '{print $2}')
    AWS_REGION=$(grep -E '^aws_region\s*=' terraform.tfvars | awk -F'"' '{print $2}')
fi

# Read DynamoDB table name from backend.tf
DYNAMODB_TABLE=$(grep -E 'dynamodb_table\s*=' *.tf | awk -F'"' '{print $2}')

# Set the LockID (you may need to adjust this based on your project structure)
#LOCK_ID="${PWD##*/}/terraform.tfstate"


KEY=$(cat *.tf  | awk --field-separator='"' '/^ *key *=/ { print $2 } ')
BUCKET=$(cat *.tf  | awk --field-separator='"' '/^ *bucket *=/ { print $2 } ')
LOCK_ID="${BUCKET}/${KEY}"

set | egrep '^(AWS_(PROFILE|REGION)|DYNAMODB_TABLE|KEY|BUCKET|LOCK_ID)=' | column --table --separator = --output-separator ': ' --table-right 1 | sed 's/^/    /'

# Function to query the lock state
query_lock() {
    aws dynamodb get-item \
        --table-name "$DYNAMODB_TABLE" \
        --key '{"LockID": {"S": "'"$LOCK_ID"'"}}' \
        ${AWS_REGION:+--region "$AWS_REGION"} \
        ${AWS_PROFILE:+--profile "$AWS_PROFILE"}
}

# Function to release the lock
release_lock() {
    aws dynamodb delete-item \
        --table-name "$DYNAMODB_TABLE" \
        --key '{"LockID": {"S": "'"$LOCK_ID"'"}}' \
        ${AWS_REGION:+--region "$AWS_REGION"} \
        ${AWS_PROFILE:+--profile "$AWS_PROFILE"}
}

# Main script
arg="${1:-empty}"
case "${arg}" in
    query)
	    q=$(query_lock)
	    if [ -z "${q}" ] ; then
		    echo "lock ${LOCK_ID} is not held"
	    else
		    echo "lock ${LOCK_ID} is held"
	    fi	

        ;;
    release)
        release_lock
        ;;
    *)
	    echo "Usage: $0 {query|release} (arg: ${arg})"
        exit 1
        ;;
esac

