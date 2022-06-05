#!/bin/bash

# -------------------------------------------------- #
# 	   This file contains all system functions       #
# -------------------------------------------------- #

# Display options. Add client / remove client / Add group / remove group / Patching
function system_menu {
    echo "Selected System menu"
    system_menu_select=$(
		whiptail --title "PiCaster Management - System Menu" \
				 --menu "
                        
                        System management menu.
                        " 18 78 7 3>&1 1>&2 2>&3 \
           		        "<--" "BACK                " \
				 		"Add Client" "   Client Management" \
				 		"Remove Client" "   Client Management" \
						"Add Group" "   Group Management" \
						"Remove Group" "   Group Management" \
						"Schedule" "   Set Automatic ON/OFF Time" \
						"Patching" "   Patch Management"
    )
    # Call funtion depending on menu choice.
    if [[ $system_menu_select = "Add Client" ]]
    then
        echo "Add Client"
        system_add_client
    elif [[ $system_menu_select = "Remove Client" ]]
    then
        echo "Remove Client"
        system_remove_client
    elif [[ $system_menu_select = "Add Group" ]]
    then
        echo "Add Group"
        system_add_group
    elif [[ $system_menu_select = "Remove Group" ]]
    then
        echo "Remove Group"
        system_remove_group
    elif [[ $system_menu_select = "Schedule" ]]
    then
        echo "Schedule"
        system_schedule
    elif [[ $system_menu_select = "Patching" ]]
    then
        echo "Patching"
        system_patching
    elif [[ $? -eq 1 ]]
    then
        echo "Cancel pressed. Exiting..."
        sleep 2
        clear
        exit
    else
        clear
        echo "Invalid selection"
        sleep 3
        select_menu
    fi
}

# System Schedule
function system_schedule {
    #sleep 3
    echo "System schedule"

    system_schedule_menu=$(
        whiptail --title "PiCaster Management - System Schedule" \
                 --menu "
                  Set automatic ON and OFF time for screens.
                            Currently set to:
                               ON: 07:30
                              OFF: 18:30

                        " 16 78 3 3>&1 1>&2 2>&3 \
                        "<--" "BACK                " \
                        "ON" "   Set time to turn screens ON" \
                        "OFF" "   Set time to turn screens OFF" 
    )
    # Call funtion depending on menu choice.
    if [[ $system_schedule_menu = "<--" ]]
	then
		system_menu
    elif [[ $system_schedule_menu = "ON" ]]
    then
        echo "Set ON time"
        sleep 3
        system_schedule_on=$(
            whiptail --title "PiCaster Management - System Schedule" \
                     --inputbox "
                      Set time to turn screens ON.

           Time must be entered without as follows: 0700 or 1930.
            Do NOT use separator characters. 07:00 will NOT work
                 " 12 80 3>&1 1>&2 2>&3
        )
        if [[ -z "$system_schedule_on" ]]
        then
            clear
            echo "No time provided"
            sleep 3
            system_schedule
        elif [[ ! -z "$system_schedule_on" ]]
        then
            echo "Time provided"
            #ansible-playbook add-group.yml -e "groupname="$system_add_group_name" url="$system_add_group_url""
            sleep 3
            system_schedule
        elif [[ $? -eq 1 ]] 
        then
            echo "Cancel pressed. Exiting..."
            sleep 1
            #clear
            #exit
            system_schedule
        fi
    elif [[ $system_schedule_menu = "OFF" ]]
    then
        echo "Set OFF time"
        sleep 3
        system_schedule_on=$(
            whiptail --title "PiCaster Management - System Schedule" \
                     --inputbox "
                      Set time to turn screens OFF.

           Time must be entered without as follows: 0700 or 1930.
            Do NOT use separator characters. 07:00 will NOT work
                 " 12 80 3>&1 1>&2 2>&3
        )
        if [[ -z "$system_schedule_off" ]]
        then
            clear
            echo "No time provided"
            sleep 3
            system_schedule
        elif [[ ! -z "$system_schedule_off" ]]
        then
            echo "Time provided"
            #ansible-playbook add-group.yml -e "groupname="$system_add_group_name" url="$system_add_group_url""
            sleep 3
            system_schedule
        elif [[ $? -eq 1 ]] 
        then
            echo "Cancel pressed. Exiting..."
            sleep 1
            #clear
            #exit
            system_schedule
        fi
    elif [[ $? -eq 1 ]]
    then
        echo "Cancel pressed. Exiting..."
        sleep 2
        clear
        exit
    else
        clear
        echo "Invalid selection"
        sleep 3
        system_menu
    fi
    system_menu
}

# Add Group
function system_add_group {
    echo "System Add Group"

    system_add_group_name=$(
        whiptail --title "PiCaster Management - Add Group" \
                 --inputbox "
                  Enter the name of the new group.

             Names can not have spaces or special characters.
                 " 12 80 3>&1 1>&2 2>&3
    )
    if [[ -z "$system_add_group_name" ]]
    then
        clear
        echo "No name provided"
        sleep 3
        system_add_group
    elif [[ ! -z "$system_add_group_name" ]]
    then
        echo "Group name provided"
        system_add_group_url=$(
            whiptail --title "PiCaster Management - Add Group" \
                    --inputbox "
        Enter the URL of the page you want the group to display.
                    Including the "https://" part

  To play a youtube video/ stream in fullscreen use the following format. 
                 (This only works on embedable videos)

           https://www.youtube.com/embed/<VIDEOID?autoplay=1

                    " 18 80 3>&1 1>&2 2>&3
        )
        if [[ -z "$system_add_group_url" ]]
        then
            clear
            echo "No URL provided"
            sleep 3
            system_add_group
        elif [[ ! -z "$system_add_group_url" ]]
        then
            echo "Group URL provided"
            ansible-playbook add-group.yml -e "groupname="$system_add_group_name" url="$system_add_group_url""
            sleep 3
            system_menu
        elif [[ $? -eq 1 ]] 
        then
            echo "Cancel pressed. Exiting..."
            sleep 1
            #clear
            #exit
            system_menu
        fi
    fi

    system_menu
}

# Add client. Name / IP / URL
function system_add_client {
    echo "Add Client"

    system_add_client_name=$(
        whiptail --title "PiCaster Management - Add Client" \
                 --inputbox "
                  Enter the name of the new client.

             Names can not have spaces or special characters.
                 " 12 80 3>&1 1>&2 2>&3
    )
    if [[ -z "$system_add_client_name" ]]
    then
        # clear
        echo "No name provided"
        sleep 3
        system_add_client
    elif [[ ! -z "$system_add_client_name" ]]
    then
        echo "Client name provided"
        #clear
        system_add_client_ip=$(
            whiptail --title "PiCaster Management - Add Client" \
                    --inputbox "
                    Enter the IPv4 of the new client.

                  Enter the IP in the following format:
                           192.168.1.150
                    " 12 80 3>&1 1>&2 2>&3
        )
        if [[ -z "$system_add_client_ip" ]]
        then
            # clear
            echo "No IP provided"
            sleep 3
            system_add_client
        elif [[ ! -z "$system_add_client_ip" ]]
        then
            echo "Client IP provided"
            #clear
            system_add_client_url=$(
                whiptail --title "PiCaster Management - Add Client" \
                        --inputbox "
        Enter the URL of the page you want the client to display.
                    Including the "https://" part

  To play a youtube video/ stream in fullscreen use the following format. 
                 (This only works on embedable videos)

           https://www.youtube.com/embed/<VIDEOID?autoplay=1

                        " 18 80 3>&1 1>&2 2>&3
            )
            if [[ -z "$system_add_client_url" ]]
            then
                clear
                echo "No URL provided"
                sleep 3
                system_add_client
            elif [[ ! -z "$system_add_client_url" ]]
            then
                #echo "URL provided"
                clear
                # Fire the playbook
                # ansible-playbook update-device-url.yml -e "target=afspeelapparaat1 target_url=https://www.youtube.com/embed/db0A0Jt2Al4?autoplay=1"
                #echo "ansible-playbook update-device-url.yml -e 'target="$selected_client" target_url="$set_client_url"'"
                #ansible-playbook update-device-url.yml -e "target="$selected_client" target_url="$set_client_url""
                ansible-playbook add-device.yml -e "ip="$system_add_client_ip" alias="$system_add_client_name" url="$system_add_client_url""
                # Pause for 3 seconds
                sleep 3
                # Return to client screen
                system_menu
            elif [[ $? -eq 1 ]] 
            then
                echo "Cancel pressed. Exiting..."
                sleep 1
                #clear
                #exit
                system_menu
            fi
        elif [[ $? -eq 1 ]] 
        then
            echo "Cancel pressed. Exiting..."
            sleep 1
            #clear
            exit
        fi
    elif [[ $? -eq 1 ]] 
	then
		echo "Cancel pressed. Exiting..."
		sleep 1
		#clear
		exit
    fi
}

# Remove client. List
function system_remove_client {
    echo "Remove Client"
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
    system_remove_selected_client=$(
        whiptail --title "PiCaster Management - Remove Client" \
                 --menu "
                         Select Client to remove.
                          THIS CAN NOT BE UNDONE
                          " 20 80 8 3>&1 1>&2 2>&3 \
                 "<--" "BACK                " \
                 "${clients_menu[@]}"
    )
    # Call funtion depending on menu choice.
    if [[ $system_remove_selected_client = "<--" ]]
    then
        system_menu_select
    elif [[ ! -z "$system_remove_selected_client" ]]
    then
        echo "Client selected"
        echo "$system_remove_selected_client"
        ansible-playbook remove-device.yml -e "device_name="$system_remove_selected_client""
        sleep 3
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
    system_menu
}

# Remove group. List
function system_remove_group {
    echo "Remove Group"

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

	system_remove_selected_group=$(
		whiptail --title "PiCaster Management - Remove Group" \
				 --menu "
				 	      Select Group to remove.
                          THIS CAN NOT BE UNDONE
                          " 20 80 8 3>&1 1>&2 2>&3 \
           		 "<--" "BACK                " \
                 "${group_list[@]}"
	)
	if [[ $system_remove_selected_group = "<--" ]]
	then
		system_menu
	elif [[ ! -z "$system_remove_selected_group" ]]
	then
        #echo "group " $selected_group " selected"
		#sleep 3

        # REMOVE SELECTED GROUP
        ansible-playbook remove-group.yml -e "group_name="$system_remove_selected_group""
        sleep 3
		system_menu

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
		system_menu
	fi
    sleep 3
    system_menu
}

# # Set time to turn on/ off
# function system_set_timers {
#     echo "Set Timers"
#     sleep 3
#     system_menu
# }

# Patching. Single client / All clients
function system_patching {
    echo "System Patching"
    # Create menu and store result in variable.
    system_patching_menu=$(
        whiptail --title "PiCaster Management - Select Menu" \
                 --menu "
                        Select management menu." 12 78 3 3>&1 1>&2 2>&3 \
                        "<--" "BACK                " \
                        "Single Client" "   Client Management." \
                        "All Clients" "   Group Management." 
    )
    # Call funtion depending on menu choice.
    if [[ $system_patching_menu = "<--" ]]
	then
		system_menu
    elif [[ $system_patching_menu = "Single Client" ]]
    then
        system_patching_single
    elif [[ $system_patching_menu = "All Clients" ]]
    then
        # Patching all clients
        ansible-playbook update-device-packages.yml -e "target=all"
        sleep 3
    elif [[ $? -eq 1 ]]
    then
        echo "Cancel pressed. Exiting..."
        sleep 2
        clear
        exit
    else
        clear
        echo "Invalid selection"
        sleep 3
        system_menu
    fi
    system_menu 
}

# Patching single client. List
function system_patching_single {
    echo "Patch Client"
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
    system_patch_selected_client=$(
        whiptail --title "PiCaster Management - Patch Client" \
                 --menu "
                          Select Client to patch.
                          
                          " 20 80 8 3>&1 1>&2 2>&3 \
                 "<--" "BACK                " \
                 "${clients_menu[@]}"
    )
    # Call funtion depending on menu choice.
    if [[ $system_patch_selected_client = "<--" ]]
    then
        system_menu_select
    elif [[ ! -z "$system_patch_selected_client" ]]
    then
        echo "Client selected"
        echo "$system_patch_selected_client"
        ansible-playbook update-device-packages.yml -e "target="$system_patch_selected_client""
        sleep 3
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
    system_menu    
}
