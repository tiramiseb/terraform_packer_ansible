#!/bin/sh

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

cd ..
