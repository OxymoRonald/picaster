#!/bin/bash

# -------------------------------------------------- #
# 	   This file contains all client functions       #
# -------------------------------------------------- #

# -------------------------------------------------- #
# 	        Display a list of all clients            #
# -------------------------------------------------- #

# Whiptail default outputs to stderr instead of stdout the "3>&1 1>&2 2>&3" switches it back to normal.
function client_menu {
    echo "Selected Client menu"
    # # Create menu screen and store result in variable
    # client_select=$(
    #     whiptail --title "PiCaster Management - Select Client"
    #              --menu "
    #                     Select client." 18 78 6 3>&1 1>&2 2>&3 \
	# 			 		"Client1" "   Client Management." \
	# 					"Group2" "   Group Management." \
	# 					"System6" "   System Management."
    # )
    # # $? # Exit status. 0 = OK, 1 = Cancel

    # # Call funtion depending on menu choice.
    # if [[ $client_select = "Client1" ]]
    # then
    #     client_select
    # elif [[ $client_select = "Group2" ]]
    # then
    #     group_menu
    # elif [[ $client_select = "System6" ]]
    # then
    #     system_menu
    # elif [[ $? -eq 1 ]]
    # then
    #     echo "Cancel pressed. Exiting..."
    #     sleep 2
    #     clear
    #     exit
    # else
    #     clear
    #     echo "Invalid selection"
    #     sleep 3
    #     select_menu
    # fi
}






# Display client specifics. Name / IP / TargetURL / Groups
# Options. Set URL / Add to group / Remove from group / Reset

# Set URL. client

# Add to group client
# List groups

# Remove from group
# List groups
