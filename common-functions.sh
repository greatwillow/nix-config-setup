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
	if [[ "$OSTYPE" == "linux"* ]]; then
	   eval $1="true"
	else
	   eval $1="false"
	fi
}

check_is_mac_os() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
	   eval $1="true"
	else
	   eval $1="false"
	fi
}

read_secret()
{
    # Disable echo.
    stty -echo

    # Set up trap to ensure echo is enabled before exiting if the script
    # is terminated while echo is disabled.
    trap 'stty echo' EXIT

    # Read secret.
    read "$@"

    # Enable echo.
    stty echo
    trap - EXIT

    # Print a newline because the newline entered by the user after
    # entering the passcode is not echoed. This ensures that the
    # next line of output begins at a new line.
    echo
}

