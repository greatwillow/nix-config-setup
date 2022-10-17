#!/bin/bash

sudo chsh -s $(which bash) $USER

base_url="https://raw.githubusercontent.com/greatwillow/"
repository_name="nix-config-setup"
branch_name="main"
1_setup_user_script_name="1-setup-user.sh" 
2_install_nix_script_name="2-install-nix.sh"

file_names=(
	$1_setup_user_script_name
	$2_install_nix_script_name
)

for file_name in "${file_names[@]}"
do
   curl "$base_url$repository_name/$branch_name/$file_name" -O
done

source $1_setup_user_script_name

print_line "Enter the username from the above list which you would like to install this system on."
read selected_user

echo "You are currently switching to another prompt as user: $selected_user"
echo ""

su -P -s $(which bash) -l $selected_user -c "cd /nix-config-setup; bash $2_install_nix_script_name;"