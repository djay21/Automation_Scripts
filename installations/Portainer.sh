#!/bin/bash

apt install apache2-utils -y
read -p "\n\nEnter your password: " pass
echo -e "\nPortainer Password is ${pass}"
password=$(htpasswd -nb -B admin ${pass} | cut -d ":" -f 2)
echo "Encrypted password is : $password"
docker run -d -p 6060:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer --admin-password ${password} || sudo docker run -d -p 8004:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer --admin-password ${password}
