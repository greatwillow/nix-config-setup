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

	if [[ $is_linux_os == "true" ]]; then 
		sudo useradd -m $user_name							# Add New User
		sudo usermod -a -G sudo $user_name					# Add New User to sudoers group
		sudo passwd $user_name								# Prompt for password for new user
	fi

	if [[ $is_mac_os == "true" ]]; then 
		dscl . -create /Users/$user_name					# Add New User
		print_line "Please enter a new user password:"		# Prompt for password for new user
		read user_password
		dscl / -passwd /Users/$user_name $user_password					
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
	2_install_nix_script_name="2-install-nix.sh"
	3_install_nix_config_script_name="3-install-nix-config.sh"

	file_names=(
		$2_install_nix_script_name
		$3_install_nix_config_script_name
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
	bash $2_install_nix_script_name
}

switch_to_selected_user() {
	su -P -s $(which bash) -l $selected_user -c setup_selected_user
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
