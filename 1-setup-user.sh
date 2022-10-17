#!/bin/bash

# This file is used to manage the initial setup of the environment 
# with a non-root user.

#===============================================================================
# Functions
#===============================================================================

source _common_functions

print_users_list() {
	print "Current available non root users are:"
	grep ':/home' /etc/passwd | awk -F ':' '{print $1}'
}

check_if_is_root_user() {
	is_mac_os="false"
	is_linux_os="false"
	[[ "$OSTYPE" == "darwin"* ]] && is_mac_os="true"
	[[ "$OSTYPE" == "linux"* ]] && is_linux_os="true"
	current_user=$(whoami)

	if [[ $is_linux_os == "true" && $current_user == "root" ]]; then
		print_line "It looks like you are currently logged in as a root user. This installation will only work for non root users."
	fi
}

create_new_user() {
	print_line "Would you like to create another user? (y or n)"
	read should_create_new_user

	[[ $should_create_new_user != "y" ]] && return

	print_line "Please enter a new user name:"
	read user_name
	sudo useradd -m $user_name				# Add New User
	sudo usermod -a -G sudo $user_name		# Add New User to sudoers group
	sudo passwd $user_name					# Prompt for password for new user
}

#===============================================================================
# Program
#===============================================================================

cd $HOME
check_if_is_root_user
print_users_list
create_new_user
print_users_list 
