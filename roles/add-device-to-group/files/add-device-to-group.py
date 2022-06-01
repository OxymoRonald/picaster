#!/usr/bin/python3

# Import modules
import yaml
import sys
from datetime import datetime

# Set variables
inventory_directory = "/home/picaster/picaster/"
inventory_file = inventory_directory + "inventory.yml"
inventory_device = sys.argv[1]
inventory_group = sys.argv[2]

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

# Add device to group
inventory_dict['all']['children'][inventory_group]['hosts'].update({inventory_device : None})

# Remove dummy host from group
try: 
    del inventory_dict['all']['children'][inventory_group]['hosts']['dummy']
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