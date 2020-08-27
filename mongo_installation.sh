#!/bin/bash

wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

#adding 4.4 repo 
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

#updating binaries
sudo apt-get update

#installing mongo
sudo apt-get install -y mongodb-org

#start mongo on start up 
sudo systemctl enable mongod

exit 0
