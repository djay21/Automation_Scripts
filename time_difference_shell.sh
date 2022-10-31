#!/bin/bash

function call_time_diff() {
        echo "Created on: $1";
        today_date=$(date +%Y%m%d);
        date_diff=$(echo $(( ($(date --date=$today_date +%s) - $(date --date=$1 +%s) )/(60*60*24) )));
        echo -e "Time Difference is - $date_diff days\n";
        if [[ $date_diff -ge 7 ]];
        then
            echo -e "\033[0;31m  XXXXX Delete it XXXXXX \033[0m";
        fi
}

function password_check() {
#    echo "Starting Function Password Check";
    az ad sp credential list --id $i; 
    if [[ $? == 0 ]];
    then
      for k in $(az ad sp credential list --id $i | grep startDate | cut -d ":" -f 2 | tr -d "\ "\"\-"" | cut -c -8);
      do
      echo "Password  - $(az ad sp credential list --id $i --cert | grep keyId)"
      call_time_diff $k
      done
    else
      echo "dont do password "
    fi
}

function certificate_check() {
 #   echo "Starting Function Certificate Check";
    az ad sp credential list --id $i --cert ; 
    if [[ $? == 0 ]];
    then
      for j in $(az ad sp credential list --id $i --cert | grep startDate | cut -d ":" -f 2 | tr -d "\ "\"\-"" | cut -c -8);
      do
       echo "Certificate - $(az ad sp credential list --id $i --cert | grep keyId)"
       call_time_diff $j
      done
    fi
}

sp_list=$(az ad sp list --all  --query '[].appId' | tr -d "\ "\"\,\[\]"")
for i in $sp_list;
do
echo -e "\n****** starting function password and certificate check for $i ***********"
password_check
certificate_check
done
