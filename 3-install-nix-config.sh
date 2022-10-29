#!/bin/bash

# This automates the download and installation of the desired nix-config setup.

base_url="https://github.com/greatwillow/"
repository_name="nix-config"
branch_name="main"
nix_config_url="${base_url}/${repository_name}/archive/refs/heads/${branch_name}.tar.gz"

#===============================================================================
# Functions
#===============================================================================

source common-functions.sh

query_for_alternate_nix_config_url() {
	print_line "You are currently set to load the nix config at $nix_config_url"
	print_line "Would you like to continue with the default selection? (y or n)"
	read use_default_nix_config_url

	if [[ $use_default_nix_config_url != "y" ]]; then
		print_line "What is the nix-config url you would like to use?"
		read nix_config_url
	fi
}

download_and_extract_nix_config() {
	local nix_config_directory="$HOME/nix-config"
	local nix_config_tar_file="$HOME/nix-config.tar.gz"

	curl $1 -L -o "$HOME/nix-config.tar.gz"

	tar -xzvf $nix_config_tar_file
	mv "$nix_config_directory-${branch_name}" $nix_config_directory
	rm -f $nix_config_tar_file
}

#===============================================================================
# Program
#===============================================================================

cd $HOME
query_for_alternate_nix_config_url
download_and_extract_nix_config $nix_config_url