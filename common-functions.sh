#!/bin/bash

print_line() {
	printf "\n$1\n"
}

print_header() {
	printf "\n------------------------------------------------------------------------------\n$1\n------------------------------------------------------------------------------\n"
}

reload_shell() {
	exec ${SHELL} -l
}

check_is_linux_os() {
	if [ "$OSTYPE" = "linux"* ]; then
	   eval $1="true"
	else
	   eval $1="false"
	fi
}

check_is_mac_os() {
	if [ "$OSTYPE" = "darwin"* ]; then
	   eval $1="true"
	else
	   eval $1="false"
	fi
}
