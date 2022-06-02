#!/usr/bin/python3

# Import modules
import yaml
import csv
import sys
import argparse

# Set variables
artifact_directory = "/home/picaster/picaster/artifacts/"
home_directory = "/home/picaster/picaster/"
inventory_file = home_directory + "inventory.yml"

# Open inventory file as read only and store in dictionary.
inventory = open(inventory_file, "r")
# Load inventory as dictionary
# FullLoader parameter handles conversion from YAML scalar values to Python the dictionary format
inventory_dict = yaml.load(inventory, Loader=yaml.FullLoader)
# Close inventory file
inventory.close()

#Pretty print the inventory
# print(">> Pretty print inventory <<")
# print(yaml.dump(inventory_dict, default_flow_style=False))

# Initiate argparse
parser=argparse.ArgumentParser()
parser.add_argument("--listgroups", help="Creates a list of all groups", action="store_true")
parser.add_argument("--groupinfo", help="Gets info on specific group", metavar="group_name")
args = parser.parse_args()

# If --listclients is set
if args.listgroups:

    # Open CSV file
    with open(artifact_directory + "grouplist.csv", 'w', newline='') as file:
        # create writer
        writer = csv.writer(file, delimiter='\t')

        # Write header to CSV
        header = ['name', 'url']
        writer.writerow(header)

        # Write group data to CSV
        for key in inventory_dict['all']['children']:
            #print(key)
            #print(key + "," + inventory_dict['all']['children'][key]['vars'][key+'_url'])
        #     #data = [key, " - "+inventory_dict['all']['hosts'][key]['ansible_host'],inventory_dict['all']['hosts'][key]['target_url']]
            data = [key, inventory_dict['all']['children'][key]['vars'][key+'_url']]
            writer.writerow(data)

if args.groupinfo:
    
    with open(artifact_directory + "groupinfo.csv", 'w', newline='') as file:
        # create writer
        writer = csv.writer(file, delimiter='\t')

        # Write header to CSV
        header = ['name', 'url', 'members',""]
        writer.writerow(header)

        # List all group members
        memberlist = ""
        for key in inventory_dict['all']['children'][args.groupinfo]['hosts']:
            #print(key)
            memberlist += key +"_"
        memberlist = memberlist[:-1]
        #print(memberlist)
        data = [args.groupinfo, inventory_dict['all']['children'][args.groupinfo]['vars'][args.groupinfo +"_url"], memberlist,""]
        writer.writerow(data)