#!/usr/bin/python3

# Import modules
import yaml
import sys

# Set variables
inventory_directory = "/home/picaster/picaster/"
inventory_file = inventory_directory + "inventory.yml"
inventory_group = sys.argv[1]

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

# Get URL for group

url = inventory_dict['all']['children'][inventory_group]['vars'][inventory_group + "_url"]

# To remove the newline at the end of print set the "end" argument
print(url, end='')