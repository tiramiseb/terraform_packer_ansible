#!/bin/sh
#
# This script must be executed from the repository base directory

mkdir -p local_bin
cd local_bin

if [ -f terraform ]
then
    echo "    → Terraform is already installed"
else
    echo "    → Downloading and extracting Terraform 0.9.5"
    wget https://releases.hashicorp.com/terraform/0.9.5/terraform_0.9.5_linux_amd64.zip
    unzip terraform_0.9.5_linux_amd64.zip
    rm terraform_0.9.5_linux_amd64.zip
fi

if [ -f packer ]
then
    echo "    → Packer is already installed"
else
    echo "    → Downloading and extracting Packer 1.0.0"
    wget https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_linux_amd64.zip
    unzip packer_1.0.0_linux_amd64.zip
    #rm packer_1.0.0_linux_amd64.zip
fi

cd ..

echo "    → Initializing secrets, etc"

. ./locally 2>/dev/null

if [ -z "$AWS_ACCESS_KEY" ]
then
    read -p "Please provide your AWS access key (see the IAM service): " AWS_ACCESS_KEY
fi
if [ -z "$AWS_SECRET_KEY" ]
then
    read -p "Please provide your AWS secret key (see the IAM service): " AWS_SECRET_KEY
fi
if [ -z "$AWS_LOGIN_SERVER" ]
then
    read -p "Please provide your AWS ECR login server (see the ECS service): " AWS_LOGIN_SERVER
fi
sed "s|ACCESS_KEY_HERE|$AWS_ACCESS_KEY|;s|SECRET_KEY_HERE|$AWS_SECRET_KEY|" authentication.tf.template > authentication.tf
sed "s|ACCESS_KEY_HERE|$AWS_ACCESS_KEY|;s|SECRET_KEY_HERE|$AWS_SECRET_KEY|;s|LOGIN_SERVER_HERE|$AWS_LOGIN_SERVER|" locally.template > locally

