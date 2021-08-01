#!/bin/bash
echo Hello World --- build
apt update && sudo apt upgrade -y
apt install curl -y
curl --version
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip -o awscliv2.zip
unzip awscliv2.zip
./aws/install
aws --version