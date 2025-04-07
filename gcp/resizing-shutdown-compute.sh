#!/bin/bash 

function k8s(){
for i in $(gcloud container clusters list  | awk '{print $1}' | grep -vE NAME);
do 
if [[ $i == *"-dr-"* ]];
then 
region="asia-south2"
else 
region="asia-south1"
fi
echo "Region is $region"
if [[ $1 == "stop" ]];
then
gcloud container clusters resize $i --num-nodes=0 --region=$region --quiet
elif [[ $1 == "start" ]];
then
gcloud container clusters resize $i --num-nodes=3 --region=$region --quiet
fi
done 
}

function vms(){
check_running_instances=$(gcloud compute instances list | grep RUNNING | awk '{print $1}')
if [[ $$check_running_instances == "" ]];
then
  echo -e "\n********************** All instances are already in stopped state ***************"
else
   echo -e "\n\t\t\t\tStarting VM Schedular .............."
  for instance_name in $(gcloud compute instances list | grep RUNNING | awk '{print $1}');
  do
    echo "Instance Name is : $instance_name";
    zone=$(gcloud compute instances list | grep $instance_name | awk '{print $2}')
    if [[ $instance_name == "gke"* ]];
    then
      echo -e "Gke node. Skipping Shutdown for Instance: $instance_name \n"
    else
      echo "Stopping Instance :** $instance_name **"
        if [[ $1 == "stop" ]];
        then
        gcloud compute instances $1 $instance_name --zone=$zone
        elif [[ $1 == "start" ]];
        then
        gcloud compute instances $1 $instance_name --zone=$zone
        fi
    fi
done
fi
}


function sql() {
for i in $(gcloud sql instances list | awk '{print $1}' | grep -vE NAME);
do
if [[ $1 == "stop" ]];
then
  if [[ $i == *"replica"* ]]
  then
  gcloud sql instances patch $i --no-enable-database-replication --quiet
  else
  gcloud sql instances patch $i --activation-policy=NEVER --quiet
  fi
elif [[ $1 == "start" ]];
then
  if [[ $i == *"replica"* ]]
  then
  gcloud sql instances patch $i --enable-database-replication --quiet
  else
  gcloud sql instances patch $i --activation-policy=ALWAYS --quiet
  fi
fi
done
}

action="stop"
for i in ax-gpay-p-pdr-psp-1742 ax-gpay-u-psp-cert-6e25 ax-gpay-u-udr-psp-8d59 ;
do 
echo "Project Name is $i"
gcloud config set project $i;
k8s $action 
vms $action
sql $action
done
#ax-gpay-u-udr-psp-8d59 