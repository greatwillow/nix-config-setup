#!/bin/bash

# This file is used to manage the initial setup of the environment 
# with a non-root user.

#===============================================================================
# Functions
#===============================================================================
chsh -s $(which bash) $USER

source common-functions.sh

check_is_mac_os is_mac_os
check_is_linux_os is_linux_os

print_users_list() {
	print "Current available non root users are:"

	if [[ $is_linux_os == "true" ]]; then 
	 	grep ':/home' /etc/passwd | awk -F ':' '{print $1}'
	fi

	if [[ $is_mac_os == "true" ]]; then
		dscl . list /Users
	fi 
}

check_if_is_root_user() {
	current_user=$(whoami)

	if [[ is_linux_os == "true" && $current_user == "root" ]]; then
		print_line "It looks like you are currently logged in as a root user. This installation will only work for non root users."
	fi
}

create_new_user() {
	print_line "Would you like to create another user? (y or n)"
	read should_create_new_user

	[[ $should_create_new_user != "y" ]] && return

	print_line "Please enter a new user name:"
	read user_name
	print_line "Please enter a password for new user: $user_name"		# Prompt for password for new user
	read_secret user_password

	if [[ $is_linux_os == "true" ]]; then 
		sudo useradd -m $user_name							# Add New User
		sudo usermod -a -G sudo $user_name					# Add New User to sudoers group
		sudo passwd $user_password								# Prompt for password for new user
	fi

	if [[ $is_mac_os == "true" ]]; then 
		full_name=$user_name
		# Find out the next available user ID
		max_id=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
		user_id=$((max_id+1))

		sudo dscl . -create /Users/$user_name					# Add New User
		sudo dscl . -create /Users/$user_name UserShell /bin/bash
		sudo dscl . -create /Users/$user_name RealName $full_name
		sudo dscl . -create /Users/$user_name UniqueID $user_id
		sudo dscl . -create /Users/$user_name PrimaryGroupID 20
		sudo dscl . -create /Users/$user_name NFSHomeDirectory /Users/$user_name

		sudo dscl / -passwd /Users/$user_name $user_password

		secondary_groups=""  # for a non-admin user
		#secondary_groups="admin _lpadmin _appserveradm _appserverusr"

		for group in $secondary_groups ; do
    		sudo dseditgroup -o edit -t user -a $user_name $group
		done

		# Create the home directory
		sudo createhomedir -c > /dev/null					
	
		echo "Created user #$user_id: $user_name ($full_name)"
	fi
}

select_user() {
	print_line "Enter the username from the above list which you would like to install this system on."
	read selected_user

	echo "You are currently switching to another prompt as user: $selected_user"
	echo ""
}

download_script_files() {
	base_url="https://raw.githubusercontent.com/greatwillow/"
	repository_name="nix-config-setup"
	branch_name="main"

	file_names=(
		"2-install-nix.sh"
		"3-install-nix-config.sh"
	)

	for file_name in "${file_names[@]}"
	do
		curl "$base_url$repository_name/$branch_name/$file_name" -O
	done
}

setup_selected_user() {
	mkdir -p $HOME/nix-config-setup
	cd $HOME/nix-config-setup
	download_script_files
	bash 2-install-nix.sh
}

switch_to_selected_user() {
	if [[ $is_linux_os == "true" ]]; then 
		su -P -s $(which bash) -l $selected_user -c setup_selected_user
	fi

	if [[ $is_mac_os == "true" ]]; then
		sudo su -m $selected_user 
		setup_selected_user
	fi 
}

#===============================================================================
# Program
#===============================================================================

cd $HOME
check_if_is_root_user
print_users_list
create_new_user
print_users_list 
select_user
switch_to_selected_user
