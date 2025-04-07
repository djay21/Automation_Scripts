#!/bin/bash 
StartTime="2023-01-01T00:00:00Z"
EndTime="2023-01-13T00:00:00Z"
for i in $(aws elbv2 describe-load-balancers | jq '.LoadBalancers[].LoadBalancerArn' | cut -d "/" -f 2- | grep ^net | tr -d "\"")
do 
echo "loadbalancername is : $i"
datapoints=$(aws cloudwatch get-metric-statistics --namespace AWS/NetworkELB --metric-name NewFlowCount_TCP --statistics Average  --period 3600 --dimensions Name=LoadBalancer,Value=$i --start-time $StartTime --end-time $EndTime | jq '.Datapoints[].Timestamp')
if [[ -z "$datapoints" ]]; then
  echo "loadbalancername $i is not used in this duration"
else
  echo "ok"
fi
done
