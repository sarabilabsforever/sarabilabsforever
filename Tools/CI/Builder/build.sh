#!/bin/bash
echo Hello World --- build
su vsts_azpcontainer
whoami
apt update && apt upgrade -y

