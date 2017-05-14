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

if [ -f authentication.tf ]
then
    echo "    → AWS authentication file already exists, modify it manually if needed"
else
    read -p "Please provide your AWS access key: " awskey
    read -p "Please provide your AWS secret key: " awssecret
    sed "s/ACCESS_KEY_HERE/$awskey/;s/SECRET_KEY_HERE/$awssecret/" authentication.tf.sample >> authentication.tf
fi

