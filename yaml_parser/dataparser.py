import json
import sys
import os
import yaml
def flatten_json(data, parent_key=''):
   """Recursively flattens JSON into path-value pairs."""
   items = {}
   for k, v in data.items():
       new_key = f"{parent_key}/{k}" if parent_key else k
       if isinstance(v, dict):
           items.update(flatten_json(v, new_key))
       else:
           items[new_key] = v
   return items
def yaml_to_json(file_path):
   """Reads a YAML file and converts it to a JSON object."""
   try:
       with open(file_path, 'r') as yaml_file:
           return yaml.safe_load(yaml_file)
   except Exception as e:
       print(f"Error converting YAML to JSON: {e}")
       sys.exit(1)
def read_file_as_json(file_path):
   """Reads a file and converts it to JSON if necessary."""
   _, file_extension = os.path.splitext(file_path)
   if file_extension.lower() == '.json':
       try:
           with open(file_path, 'r') as file:
               return json.load(file)
       except Exception as e:
           print(f"Error reading JSON file: {e}")
           sys.exit(1)
   elif file_extension.lower() == '.yaml' or file_extension.lower() == '.yml':
       return yaml_to_json(file_path)
   else:
       print(f"Unsupported file format: {file_extension}")
       sys.exit(1)
# Check if a filename argument is provided
if len(sys.argv) != 2:
   print("Usage: python process_json.py <file_path>")
   sys.exit(1)
file_path = sys.argv[1]
# Convert file to JSON data
json_data = read_file_as_json(file_path)
# Flatten the JSON data
flattened = flatten_json(json_data)
# Print the flattened JSON
for k, v in flattened.items():
   print(f"{k} : {v}")