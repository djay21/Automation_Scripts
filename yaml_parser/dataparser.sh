#!/bin/bash
# Check if yq is installed
if ! command -v yq &> /dev/null
then
   echo "yq is not installed. Please install it to proceed."
   exit 1
fi
# Function to create parameter names
create_parameter_name() {
   local folder=$1
   local env=$2
   path=$(echo "$3" | sed 's|^/||')
   echo "/$env/$folder/$path"
}
at=""
# Find all config YAML files in the '.' directory and its subdirectories
find . -type f -name "config_*.yaml" | while read -r filepath; do
   dir=$(dirname "$filepath")
   folder=$(basename "$dir")
   filename=$(basename "$filepath")
   # env=$(echo "$filename" | cut -d'_' -f2 | cut -d'.' -f1)
   echo "Priting values : $dir $folder $filename $env $filepath"
python3 abc.py $filepath > $filepath.txt
cat $filepath.txt
while IFS= read -r line; do
   key=$(echo $line | cut -d ":" -f 1 | tr -d ' ')
   value=$(echo $line | cut -d ":" -f 2-| tr -d ' ')
      parameter_name=$(create_parameter_name "$folder" "$env" "$key")
   if [[ $value == \$ ]];then
      value=$(eval echo "$value")
   fi
   echo "Creating SSM parameter: $parameter_name with value: $value"
        # aws ssm put-parameter \
        #   --region "$REGION" \
        #   --name "$parameter_name" \
        #   --value "$value" \
        #   --type "String" \
        #   --overwrite
done < $filepath.txt
rm -rf $filepath.txt
done