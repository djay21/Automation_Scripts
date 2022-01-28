#!/bin/bash 

set -aux
az network nic list | jq '.[] | .ipConfigurations[].subnet.id + " " + .virtualMachine.id' | cut -d "/" -f 5,9,11,19 --output-delimiter " # " | tr -d "\"" > vnet_subnet.txt
az vm list-ip-addresses --query "[].virtualMachine.[name,resourceGroup,network.privateIpAddresses,network.publicIpAddresses[].ipAddress]" -o table > ip.txt
rm -rf data.txt
for i in $(cat vnet_subnet.txt | awk -F "#" '{print $4}');
do  
a=$( grep "$i$" vnet_subnet.txt | awk  -F "#" '{print $1}') 
b=$(grep "$i$" vnet_subnet.txt | awk  -F "#" '{print $2}') 
c=$(grep "$i$" vnet_subnet.txt | awk  -F "#" '{print $3}')
d=$(az network vnet subnet show -g $a --vnet-name$b -n $c | jq '.addressPrefix'; )
#echo -e "************************$a\t\t $b\t\t $c\t\t $d**********\n"
#echo $i
e=$(grep "$i" ip.txt | awk  -F " " '{print $3}')
f=$(grep "$i" ip.txt | awk  -F " " '{print $3}')
g=$(grep "$i" ip.txt | awk  -F " " '{print $2}')
echo -e "$g $i $a $b $c $d $e $f\n" >> data.txt
#echo -e "$a\t\t $b\t\t $c\t\t $d" |awk '{$1 = sprintf("%-30s", $1) 1}' 
#awk -v a="$a\t\t" -v b="$b\t\t" -v c="$c\t\t" 'BEGIN { printf a,b,c }'
done
column -t data.txt
