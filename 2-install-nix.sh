#!/bin/sh

#===============================================================================
# Functions
#===============================================================================

source common-functions.sh

install_nix() {
	print_header "Installing Nix"
	# Installing Nix for multi-user support - https://nixos.org/manual/nix/stable/installation/installing-binary.html#multi-user-installation
	sh <(curl -L https://nixos.org/nix/install) --daemon
}

restart_shell() {
	print_header "Reloading Shell"
	print_line "Run the following command to finish the setup process -------> cd /nix-config-setup; bash 3-install-nix-config.sh"
	reload_shell
}

#===============================================================================
# Program
#===============================================================================

install_nix
restart_shell