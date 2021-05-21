!/usr/bin/env bash


apt-get update
apt-get install gnupg2 curl -y
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -


echo deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main | sudo tee /etc/apt/sources.list.d/vault.list
sudo apt-get update && sudo apt-get install vault -y

