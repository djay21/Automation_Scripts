#!/bin/bash 

#for i in $(aws s3 ls | awk '{print $3}');
no_of_days=24
for i in $(cat abc.txt | awk '{print $3}' );
do  
# for i in $(cat abc.txt | awk '{print $1}' | tr -d "-");
last_used_date=$(cat abc.txt | grep $i | awk '{print $1}' | tr -d "-");
today_date=$(date +%Y%m%d);
date_diff=$(echo $(( ($(date --date=$today_date +%s) - $(date --date=$last_used_date +%s) )/(60*60*24) )));
if [[ $date_diff -ge $no_of_days ]];
then 
echo "################List kro bucket $i ##############"
else
echo -e "***********Continue*********\n"
fi
done




#!/bin/bash 

no_of_days=180
for i in $(aws s3 ls | awk '{print $3}');
do  
last_used_date=$(aws s3 ls $i --recursive | sort | tail -n 1 | cut -d ' ' -f1 | tr -d "-")
today_date=$(date +%Y%m%d);
date_diff=$(echo $(( ($(date --date=$today_date +%s) - $(date --date=$last_used_date +%s) )/(60*60*24) )));
if [[ $date_diff -ge $no_of_days ]];
then 
echo " Bucket $i has not been used in the last $date_diff days "
else
echo -e "\n"
fi
done