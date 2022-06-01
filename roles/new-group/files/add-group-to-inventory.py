#!/usr/bin/python3

# Import modules
import yaml
import sys
from datetime import datetime

# Set variables
inventory_directory = "/home/picaster/picaster/"
inventory_file = inventory_directory + "inventory.yml"
inventory_alias = sys.argv[1]
inventory_url = sys.argv[2]

# Open inventory file as read only.
# print(">> Import inventory file read only <<")
inventory = open(inventory_file, "r")
# Load inventory as dictionary
# FullLoader parameter handles conversion from YAML scalar values to Python the dictionary format
inventory_dict = yaml.load(inventory, Loader=yaml.FullLoader)
# print(inventory_dict)
# Close inventory file
inventory.close()

#Pretty print the inventory
# print(">> Pretty print inventory <<")
# print(yaml.dump(inventory_dict, default_flow_style=False))

# Backup the inventory
# Get current time for backup
datetime_string = datetime.now().strftime("%y%m%d%H%M%S")
backupfile = open(inventory_directory + "artifacts/inventory_" + datetime_string + ".yml",'w')
backupfile.write("---\n") 
backupfile.write(yaml.dump(inventory_dict, default_flow_style=False)) 
backupfile.close()

# Add group to inventory
# print(">> Add group to inventory <<")
inventory_dict['all']['children'].update({inventory_alias: {'hosts': {'dummy': None}, 'vars': { "group_url": inventory_url}}})

# Remove dummy group from inventory
# Delete dummy entry if exists
try: 
    del inventory_dict['all']['children']['dummygroup']
except Exception:
    pass

# Pretty print new inventory
# print(">> Pretty print new inventory <<")
# print(yaml.dump(inventory_dict, default_flow_style=False))

# Overwrite inventory file
outfile = open(inventory_file,'w')
outfile.write("---\n")
outfile.write(yaml.dump(inventory_dict, default_flow_style=False))
outfile.close()
