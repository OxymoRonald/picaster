#!/bin/bash

# -------------------------------------------------- #
# 	   This file contains all general functions      #
# -------------------------------------------------- #

# -------------------------------------------------- #
# 	   Display welcome screen. (Start the menu)      #
# -------------------------------------------------- #
# This function displays the welcome screen.
function welcome {
	whiptail --title "PiCaster Management" \
			 --msgbox "\n
			       Welcome to the PiCaster Management Portal. 
			            This menusystem is keyboard only.
			              
			              Hitting <Cancel> at any time 
			                will exit the menusystem.

			               Press <Enter> to continue." \
			 --ok-button "OK" 16 78

    # Select user type menu (new/existing)
    select_menu
}


# -------------------------------------------------- #
#   What does: 3>&1 1>&2 2>&3 mean?                  # 
#                                                    #
#   The numbers are file descriptors and only the    #
#   first three (starting with zero) have a          #
#   standardized meaning:                            #
#   0 - stdin                                        #
#   1 - stdout                                       #
#   2 - stderr                                       #
#                                                    #
#   So each of these numbers in your command refer   #
#   to a file descriptor. You can either redirect a  #
#   file descriptor to a file with > or redirect it  #
#   to another file descriptor with >&               #
#                                                    #
#   The 3>&1 in your command line will create a new  #
#   file descriptor and redirect it to 1 which is    #
#   STDOUT. Now 1>&2 will redirect the file          #
#   descriptor 1 to STDERR and 2>&3 will redirect    #
#   file descriptor 2 to 3 which is STDOUT.          #
#                                                    #    
#   So basically you switched STDOUT and STDERR,     #
#   these are the steps:                             #
#                                                    #
#   1. Create a new fd 3 and point it to the fd 1    #
#      Redirect file descriptor 1 to file descriptor #
#   2. If we wouldn't have saved the file            #
#      descriptor in 3 we would lose the target.     #
#      Redirect file descriptor 2 to file descriptor #
#   3. Now file descriptors one and two are          #
#      switched.                                     #
#                                                    #
#   Now if the program prints something to the file  #
#   descriptor 1, it will be printed to the file     #
#   descriptor 2 and vice versa.                     #
# -------------------------------------------------- #

# -------------------------------------------------- #
# 	           Select management type                #
# -------------------------------------------------- #

# Whiptail default outputs to stderr instead of stdout the "3>&1 1>&2 2>&3" switches it back to normal.
function select_menu {
    # Create menu and store result in variable.
    selected_menu=$(
		whiptail --title "PiCaster Management - Select Menu" \
				 --menu "
                        Select management menu." 12 78 3 3>&1 1>&2 2>&3 \
				 		"Client" "   Client Management." \
						"Group" "   Group Management." \
						"System" "   System Management."
    )
    # Call funtion depending on menu choice.
    if [[ $selected_menu = "Client" ]]
    then
        client_menu
    elif [[ $selected_menu = "Group" ]]
    then
        group_menu
    elif [[ $selected_menu = "System" ]]
    then
        system_menu
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
