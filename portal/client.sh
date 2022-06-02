#!/bin/bash

# -------------------------------------------------- #
# 	   This file contains all client functions       #
# -------------------------------------------------- #

# -------------------------------------------------- #
# 	        Display a list of all clients            #
# -------------------------------------------------- #

# Whiptail default outputs to stderr instead of stdout the "3>&1 1>&2 2>&3" switches it back to normal.
function client_menu {
    # run python script to create list of clients
    # echo "Update client list"
    python portal/scripts/client.py --listclients 

    # echo "Selected Client menu"

    # Create a menu array for whiptail based on "artifacts/clientlist.csv"	
    clients_menu=()
	
	while IFS=$'\t' read -r line #id name # Tab separated
	do
		clients_menu+=($line)
	done < <(tail -n +2 artifacts/clientlist.csv) 
	#done < <(cut -d $'\t' -f1,2 artifacts/clientlist.csv | tail -n +2 ) 
    # cut -d "," -f1,2 Only displays column 1 and 2
    # tail -n +2 Starts it from the second line.

    #printf '%s\n' "${clients_menu[@]}"

    # echo $clients_menu
    selected_client=$(
		whiptail --title "PiCaster Management - Select Client" \
				 --menu "
                          Select existing client.
                           Use keys to navigate
                          " 20 80 8 3>&1 1>&2 2>&3 \
           		 "<--" "BACK                " \
                 "${clients_menu[@]}"
	)
    # Call funtion depending on menu choice.
    if [[ $selected_client = "<--" ]]
	then
		select_menu
	elif [[ ! -z "$selected_client" ]]
	then
        # echo "Client selected"
		client_options
	elif [[ $? -eq 1 ]] 
	then
		echo "Cancel pressed. Exiting..."
		sleep 1
		#clear
		exit
	else
		clear
		echo "Invalid option"
		sleep 3
		client_menu
	fi
}


# -------------------------------------------------- #
# 	     Display client specific information         #
# -------------------------------------------------- #

# Display client specifics. Name / IP / TargetURL / Groups
# Options. Set URL / Add to group / Remove from group / Reset
function client_options {
    #echo "We made it to the menu"
    python portal/scripts/client.py --clientinfo $selected_client

    # Load CSV file in to array
    # Create a menu array for whiptail based on "artifacts/clientlist.csv"	
    unset client_settings
    client_settings=()
	
	while IFS=$'\t' read -r line #id name # Tab separated
	do
		clients_settings=($line)
	done < <(tail -n +2 artifacts/clientinfo.csv) 
    # Print array
    # echo "${clients_settings[@]}" 
    # echo "${clients_settings[3]}"
    
    #unset client_grouplist
    client_grouplist=${clients_settings[3]}

    #username_spaced="$( echo "${user_array[$selected_user]}" | tr "_" " " )"
    #client_grouplist=${client_grouplist//_/ }
    client_grouplist=$(echo "$client_grouplist" | tr '_' ', ')
    #echo $client_grouplist

    #Groups: "${clients_settings[3]}"


    selected_client_options=$(
        whiptail --title "PiCaster Management - Client Options" \
                 --menu "
                             Client information.

                           Name: "${clients_settings[0]}"
                             IP: "${clients_settings[1]}"
                            URL: "${clients_settings[2]}" 
                         Groups: "$client_grouplist"
                        " 22 80 4 3>&1 1>&2 2>&3 \
                "<--" "   BACK" \
                "Set URL" "   Set client URL" \
                "Add to group" "   Add client to group"\
                "Remove from group" "   Remove client from group"
    )
    # To dispay a substring: ${clients_settings[2]:0:80}
    # Call funtion depending on menu choice.
    if [[ $selected_client_options = "<--" ]]
	then
		client_menu
    elif [[ $selected_client_options = "Set URL" ]]
    then
        client_set_url
    elif [[ $selected_client_options = "Add to group" ]]
    then
        client_add_group
    elif [[ $selected_client_options = "Remove from group" ]]
    then
        client_remove_group
	elif [[ $? -eq 1 ]] 
	then
		echo "Cancel pressed. Exiting..."
		sleep 1
		#clear
		exit
	else
		clear
		echo "Invalid option"
		sleep 3
		client_options
	fi
}


# -------------------------------------------------- #
# 	          Set client specific URL                #
# -------------------------------------------------- #

# Set URL. client
function client_set_url {
    echo "We made it to the SET CLIENT URL menu"

    set_client_url=$(
        whiptail --title "PiCaster Management - Set Client URL" \
                 --inputbox "
        Enter the URL of the page you want the client to display.
                    Including the "https://" part

  To play a youtube video/ stream in fullscreen use the following format. 
                 (This only works on embedable videos)

           https://www.youtube.com/embed/<VIDEOID?autoplay=1

                            " 12 80 3>&1 1>&2 2>&3
    )
    # Call function depending on choice.
	if [[ -z "$set_client_url" ]]
	then
		clear
		echo "No URL provided"
		sleep 3
		client_options
    elif [[ ! -z "$selected_client" ]]
	then
        #echo "URL provided"
        clear
        # Fire the playbook
        # ansible-playbook update-device-url.yml -e "target=afspeelapparaat1 target_url=https://www.youtube.com/embed/db0A0Jt2Al4?autoplay=1"
        #echo "ansible-playbook update-device-url.yml -e 'target="$selected_client" target_url="$set_client_url"'"
        ansible-playbook update-device-url.yml -e "target="$selected_client" target_url="$set_client_url""
        # Pause for 3 seconds
        sleep 3
        # Return to client screen
        client_options
    elif [[ $? -eq 1 ]] 
	then
		echo "Cancel pressed. Exiting..."
		sleep 1
		#clear
		exit
    fi
}

# -------------------------------------------------- #
# 	            Add client to group                  #
# -------------------------------------------------- #

# Add to group client
# List groups
function client_add_group {
    #echo "We made it to the ADD TO GROUP menu"

    # List all groups that the client isn't in
    # Update CSV
    python portal/scripts/client.py --listgroupsnotin $selected_client
    # Create a menu array for whiptail based on "artifacts/clientlist.csv"	
    client_group_menu=()
	
	while IFS=$'\t' read -r line #id name # Tab separated
	do
		client_group_menu+=($line)
	done < <(tail -n +2 artifacts/clientgroupsnotin.csv) 

    selected_client_group=$(
		whiptail --title "PiCaster Management - Add Client to Group" \
				 --menu "
                    Select group to add client to.
                        Use keys to navigate
                          " 16 80 6 3>&1 1>&2 2>&3 \
           		 "<--" "BACK                " \
                 "${client_group_menu[@]}"
	)
    # Call funtion depending on menu choice.
    if [[ $selected_client_group = "<--" ]]
	then
		select_menu
    elif [[ ! -z "$selected_client_group" ]]
	then
        echo "Client selected, add to group"
        # Add to group playbook
        # echo "ansible-playbook add-device-to-group.yml -e 'device_name="$selected_client" group_name="$selected_client_group"'"
        ansible-playbook add-device-to-group.yml -e "device_name="$selected_client" group_name="$selected_client_group""
        sleep 3
        client_options
    elif [[ $? -eq 1 ]] 
	then
		echo "Cancel pressed. Exiting..."
		sleep 1
		#clear
		exit
    fi

}


# -------------------------------------------------- #
# 	         Remove client from group                #
# -------------------------------------------------- #

# Remove from group
# List groups
function client_remove_group {
    #echo "We made it to the REMOVE FROM GROUP menu"
    # List all groups that the client isn't in
    # Update CSV
    python portal/scripts/client.py --listgroupsin $selected_client

    # Create a menu array for whiptail based on "artifacts/clientlist.csv"	
    client_group_menu=()
	
	while IFS=$'\t' read -r line #id name # Tab separated
	do
		client_group_menu+=($line)
	done < <(tail -n +2 artifacts/clientgroupsin.csv) 

    selected_client_group_remove=$(
		whiptail --title "PiCaster Management - Remove Client from Group" \
				 --menu "
                    Select group to remove client from.
                          Use keys to navigate
                          " 16 80 6 3>&1 1>&2 2>&3 \
           		 "<--" "BACK                " \
                 "${client_group_menu[@]}"
	)
    # Call funtion depending on menu choice.
    if [[ $selected_client_group_remove = "<--" ]]
	then
		select_menu
    elif [[ ! -z "$selected_client_group_remove" ]]
	then
        echo "Client selected, remove from group"
        # Add to group playbook
        #echo "ansible-playbook remove-device-from-group.yml -e 'device_name="$selected_client" group_name="$selected_client_group_remove"'"
        ansible-playbook remove-device-from-group.yml -e "device_name="$selected_client" group_name="$selected_client_group_remove""
        sleep 3
        client_options
    elif [[ $? -eq 1 ]] 
	then
		echo "Cancel pressed. Exiting..."
		sleep 1
		#clear
		exit
    fi
}
