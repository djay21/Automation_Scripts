#!/bin/bash


# - **Purpose**: Manages Azure AD service principal credentials, assessing if they should be disabled or deleted based on age.

# - **Functions**:
#   - **`call_time_diff`**: Calculates the age of a credential, flags those older than specific thresholds for potential disablement or deletion, and formats output with ANSI color codes.
#   - **`password_check`**: Lists service principal credentials and evaluates their creation dates using `call_time_diff`.
#   - **`certificate_check`**: Similar to `password_check`, but for certificates, also leveraging `call_time_diff`.

# - **Main Execution**:
#   - Retrieves all service principal IDs using Azure CLI.
#   - Iterates over each service principal, running both `password_check` and `certificate_check`.

# - **Azure CLI Usage**: Employs `az ad sp` commands to interact with Azure AD for credential listing and management.

# - **Output**: Provides descriptive output for each service principal processed, warning about any credentials requiring action.

# - **Commented Actions**: Contains commented-out Azure CLI commands for disabling or deleting credentials; these require careful manual activation.

# - **Requirements**: Assumes Azure CLI is installed, configured with necessary permissions, and standard Unix commands are available.

function call_time_diff() {
        echo "Created on: $1";
        today_date=$(date +%Y%m%d);
        date_diff=$(echo $(( ($(date --date=$today_date +%s) - $(date --date=$1 +%s) )/(60*60*24) )));
        echo -e "Time Difference is - $date_diff days";
        if [[ $date_diff -gt 7 && $date_diff -lt 14 ]];
        then
            echo -e "\033[0;31m  XXXXX Disable it XXXXXX \033[0m";
            #az ad sp update --id $i --set accountEnabled=false
        elif [[ $date_diff -gt 14 ]];
        then
          echo -e "\033[0;31m  XXXXX DELETE it XXXXXX \033[0m"; 
          if [[ "$#" == 2 ]];
          then
            echo -e "Password Deletion having APP ID: $app_id and KEY ID: $2 \n"
            #az ad sp credential delete --id $app_id --key-id $key_id --cert   #uncomment for service principal password deletion
          else
            echo -e "certificate Deletion having APP ID: $app_id and KEY ID: $2 \n"  
            #az ad sp credential delete --id $app_id --key-id $key_id         #uncomment for service principal credential deletion
            #az ad sp delete --id $i                                          #uncomment for service principal DELETION
          fi
        fi
}

function password_check() {
#    echo "Starting Function Password Check";
    az ad sp credential list --id $app_id; 
    if [[ $? == 0 ]];
    then
      for pass_created_date in $(az ad sp credential list --id $app_id | grep startDate | cut -d ":" -f 2 | tr -d "\ "\"\-"" | cut -c -8);
      do
      key_id=$(az ad sp credential list --id $app_id | grep keyId | awk '{print $2}' | tr -d "\"\,")
      echo "Password  -  $key_id"
      call_time_diff $pass_created_date $key_id
      done
    fi
}

function certificate_check() {
 #   echo "Starting Function Certificate Check";
    az ad sp credential list --id $app_id --cert ; 
    if [[ $? == 0 ]];
    then
      for i in $(az ad sp credential list --id $app_id --cert | grep -E "startDate|keyId" | awk 'NR % 2 == 1 { o=$0 ; next } { print o "" $0 }' | tr -d "\":," | tr -s " " "#");
      do
       key_id=$(echo $i | cut -d "#" -f 3)
       cert_created_date=$(echo $i | cut -d "#" -f 5 | cut -d ":" -f 2 | tr -d "\ "\"\-"" | cut -c -8)
       echo "Certificate - $key_id"
       call_time_diff $cert_created_date $key_id "cert"
      done
    fi
}

sp_list=$(az ad sp list --all  --query '[].appId' | tr -d "\ "\"\,\[\]"")
for app_id in $sp_list;
do
echo -e "\n****** starting function password and certificate check for  *** $(az ad sp list --all  --query '[].{ID:appId,NAME:displayName}' -o table | grep e34r23r-7c0c-34r23-859c-2354423423 | awk '{$1=""}1' ) -- $app_id ****"
password_check
certificate_check
done