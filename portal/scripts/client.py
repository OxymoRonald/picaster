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
parser.add_argument("--listclients", help="Creates a list of all clients", action="store_true")
parser.add_argument("--listgroupsin", help="Creates a list of all groups client is in", metavar="client_name")
parser.add_argument("--listgroupsnotin", help="Creates a list of all groups client is not in", metavar="client_name")
parser.add_argument("--clientinfo", help="Gets info on specific client", metavar="client_name")
args = parser.parse_args()

# Check which arguments are set
# If --listclients is set
if args.listclients:
    #print("List clients option is set")
    
    # Open CSV file
    #with open(artifact_directory + "clientlist.csv", 'w', encoding='UTF8', newline='') as file:
    with open(artifact_directory + "clientlist.csv", 'w', newline='') as file:
        # create writer
        writer = csv.writer(file, delimiter='\t')

        # Write header to CSV
        #header = ['name', 'ip', 'url']
        header = ['name', 'ip']
        writer.writerow(header)

        # Write client data to CSV
        for key in inventory_dict['all']['hosts']:
        #     # print(key + "," + inventory_dict['all']['hosts'][key]['ansible_host'] + "," + inventory_dict['all']['hosts'][key]['target_url'])
        #     #data = [key, " - "+inventory_dict['all']['hosts'][key]['ansible_host'],inventory_dict['all']['hosts'][key]['target_url']]
            data = [key, inventory_dict['all']['hosts'][key]['ansible_host']]
            writer.writerow(data)
    
    # # For every row found.
    # for key in inventory_dict['all']['hosts']:
    #     # Append systems
    #     file = open(artifact_directory + "clientlist.csv",'a')
    #     file.write( str(key) + "\t" + inventory_dict['all']['hosts'][key]['ansible_host'] + "\n")
    #     file.close()

# If --clientinfo is set
if args.clientinfo:
    # print(args.clientinfo)
    # Open CSV file
    with open(artifact_directory + "clientinfo.csv", 'w', newline='') as file:
        # create writer
        writer = csv.writer(file, delimiter='\t')
        
        # Write header to CSV
        header = ['name', 'ip', 'url', 'groups',""]
        writer.writerow(header)

        # List all groups the client is member of
        grouplist = ""
        for key in inventory_dict['all']['children']:
            if args.clientinfo in inventory_dict['all']['children'][key]['hosts']:
                #print("key found in "+key)
                grouplist += key + "_"
        grouplist = grouplist[:-1]
        #print(grouplist)


        # Add line to  CSV
        data = [args.clientinfo, inventory_dict['all']['hosts'][args.clientinfo]['ansible_host'], inventory_dict['all']['hosts'][args.clientinfo]['target_url'], grouplist,""]
        #data = [args.clientinfo, inventory_dict['all']['hosts'][args.clientinfo]['ansible_host'], inventory_dict['all']['hosts'][args.clientinfo]['target_url'], '"{}"'.format(grouplist)]
        writer.writerow(data)

if args.listgroupsin:
    # Open CSV file
    with open(artifact_directory + "clientgroupsin.csv", 'w', newline='') as file:
        # create writer
        writer = csv.writer(file, delimiter='\t')

        # Create header       
        header = ['groupname', 'action']
        writer.writerow(header)

        # List all groups client is member of
        for key in inventory_dict['all']['children']:
            if args.listgroupsin in inventory_dict['all']['children'][key]['hosts']:
                data = [key, "Remove"]
                writer.writerow(data)

if args.listgroupsnotin:
    # Open CSV file
    with open(artifact_directory + "clientgroupsnotin.csv", 'w', newline='') as file:
        # create writer
        writer = csv.writer(file, delimiter='\t')

        # Create header       
        header = ['groupname', 'action']
        writer.writerow(header)

        # List all groups client is member of
        for key in inventory_dict['all']['children']:
            if args.listgroupsnotin not in inventory_dict['all']['children'][key]['hosts']:
                data = [key, "Add"]
                writer.writerow(data)
                