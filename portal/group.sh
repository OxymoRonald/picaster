#!/bin/bash

# -------------------------------------------------- #
# 	    This file contains all group functions       #
# -------------------------------------------------- #

# Whiptail default outputs to stderr instead of stdout the "3>&1 1>&2 2>&3" switches it back to normal.
# List groups.
function group_menu {
    echo "Selected Group menu"
	# Update CSV 
	python portal/scripts/group.py --listgroups 

	# Create array to store data in
	group_list=()
	while IFS=$'\t' read -r line #id name # Tab separated
	do
		group_list+=($line)
	done < <(tail -n +2 artifacts/grouplist.csv) 

	# Print array
	printf '%s\n' "${group_list[@]}"

	selected_group=$(
		whiptail --title "PiCaster Management - Select Group" \
				 --menu "
				 	       Select existing group.
                           Use keys to navigate
                          " 20 80 8 3>&1 1>&2 2>&3 \
           		 "<--" "BACK                " \
                 "${group_list[@]}"
	)
	if [[ $selected_group = "<--" ]]
	then
		select_menu
	elif [[ ! -z "$selected_group" ]]
	then
        #echo "group " $selected_group " selected"
		#sleep 3
		group_menu_details
	elif [[ $? -eq 1 ]] 
	then
		echo "Cancel pressed. Exiting..."
		sleep 1
		#clear
		exit
	else
		#clear
		echo "Invalid option"
		sleep 3
		group_menu
	fi
}

# -------------------------------------------------- #
# 	      Display group specific information         #
# -------------------------------------------------- #
# Display group specifics. Name / URL / Enable / Disable
function group_menu_details {
    #echo "Selected Group menu details"
	python portal/scripts/group.py --groupinfo $selected_group

	# Load CSV
	group_details=()
	while IFS=$'\t' read -r line #id name # Tab separated
	do
		group_details=($line)
	done < <(tail -n +2 artifacts/groupinfo.csv) 
    #echo "${group_details[@]}"

	#sleep 3 
	
	group_clients=${group_details[2]}
	group_clients=$(echo "$group_clients" | tr '_' ', ')

	selected_group_options=$(
		whiptail --title "PiCaster Management - Group Options" \
				 --menu "
                              Group information.
						   Name: "${group_details[0]}"
                            URL: "${group_details[1]}" 
                        Clients: "$group_clients"
                        " 16 80 5 3>&1 1>&2 2>&3 \
                "<--" "   BACK" \
                "Set URL" "   Set group URL" \
                "Edit Members" "   Remove members from group" \
                "Enable" "   Enable group"\
                "Disable" "   Disable group"
	)
	if [[ $selected_group_options = "<--" ]]
	then
		group_menu
	elif [[ $selected_group_options = "Set URL" ]]
    then
        group_menu_set_url
	elif [[ $selected_group_options = "Edit Members" ]]
    then
        group_menu_members
	elif [[ $selected_group_options = "Enable" ]]
    then
        group_menu_enable
	elif [[ $selected_group_options = "Disable" ]]
    then
        group_menu_disable
	elif [[ $? -eq 1 ]] 
	then
		echo "Cancel pressed. Exiting..."
		sleep 1
		#clear
		exit
	else
		#clear
		echo "Invalid option"
		sleep 3
		group_menu_details
	fi
}

# -------------------------------------------------- #
# 	                Set group URL                    #
# -------------------------------------------------- #
# Set URL group.
function group_menu_set_url {
    echo "Selected Group menu url $selected_group"
	# sleep 3
	# group_menu_details


    set_group_url=$(
        whiptail --title "PiCaster Management - Set Group URL" \
                 --inputbox "
        Enter the URL of the page you want the group to display.
                    Including the "https://" part

  To play a youtube video/ stream in fullscreen use the following format. 
                 (This only works on embedable videos)

           https://www.youtube.com/embed/<VIDEOID?autoplay=1

                            " 12 80 3>&1 1>&2 2>&3
    )
	if [[ -z "$set_group_url" ]]
	then
		clear
		echo "No URL provided"
		sleep 3
		group_menu_details
    elif [[ ! -z "$set_group_url" ]]
	then
        #echo "URL provided"
        #clear
        # Fire the playbook
        # ansible-playbook update-device-url.yml -e "target=afspeelapparaat1 target_url=https://www.youtube.com/embed/db0A0Jt2Al4?autoplay=1"
        #echo "ansible-playbook update-device-url.yml -e 'target="$selected_client" target_url="$set_client_url"'"
        #ansible-playbook update-device-url.yml -e "target="$selected_client" target_url="$set_client_url""
		ansible-playbook update-group-url.yml -e "group_name="$selected_group" group_url="$set_group_url""
        # Pause for 3 seconds
        sleep 3
        # Return to group_details screen
        group_menu_details
    elif [[ $? -eq 1 ]] 
	then
		echo "Cancel pressed. Exiting..."
		sleep 1
		#clear
		exit
    fi


}

# -------------------------------------------------- #
# 	         List group members (remove)             #
# -------------------------------------------------- #
# List members. Remove client from group
function group_menu_members {
    echo "Selected Group menu members $selected_group"
	python portal/scripts/group.py --groupmembers $selected_group

	group_client_menu=()
	while IFS=$'\t' read -r line #id name # Tab separated
	do
		group_client_menu+=($line)
	done < <(tail -n +2 artifacts/groupmembers.csv) 

	selected_group_client_remove=$(
		whiptail --title "PiCaster Management - Remove Client from Group" \
				 --menu "                   
			  Select client to remove from group $selected_group.
                          Use keys to navigate
                          " 16 80 6 3>&1 1>&2 2>&3 \
           		 "<--" "BACK                " \
                 "${group_client_menu[@]}"
	)
	if [[ $selected_client_group_remove = "<--" ]]
	then
		group_menu_details
	elif [[ ! -z "$selected_group_client_remove" ]]
	then
        echo "Client selected, remove from group"
        # Add to group playbook
        #echo "ansible-playbook remove-device-from-group.yml -e 'device_name="$selected_client" group_name="$selected_client_group_remove"'"
        ansible-playbook remove-device-from-group.yml -e "device_name="$selected_group_client_remove" group_name="$selected_group""
        sleep 3
        group_menu_details
    elif [[ $? -eq 1 ]] 
	then
		echo "Cancel pressed. Exiting..."
		sleep 1
		#clear
		exit
	fi

}

# -------------------------------------------------- #
# 	                Enable group                     #
# -------------------------------------------------- #
# Enable group
function group_menu_enable {
    echo "Selected Group menu enable $selected_group"
	ansible-playbook activate-group.yml -e "group_name="$selected_group""
	sleep 3
	group_menu_details
}

# -------------------------------------------------- #
# 	                Disable group                    #
# -------------------------------------------------- #
# Disable group
function group_menu_disable {
    echo "Selected Group menu disable $selected_group"
	ansible-playbook deactivate-group.yml -e "group_name="$selected_group""
	sleep 3
	group_menu_details
}
