#!/bin/sh

#===============================================================================
# Functions
#===============================================================================

source _common_functions

install_nix() {
	print_header "Installing Nix"
	# Installing Nix for multi-user support - https://nixos.org/manual/nix/stable/installation/installing-binary.html#multi-user-installation
	sh <(curl -L https://nixos.org/nix/install) --daemon
}

restart_shell() {
	print_header "Reloading Shell"
	print_line "Run the following command to finish the setup process -------> cd /personal-setup-scripts; bash 4-install-packages.sh"
	reload_shell
}

#===============================================================================
# Program
#===============================================================================

install_nix
restart_shell