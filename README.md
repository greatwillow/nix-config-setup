# nix-config-setup
Scripts designed to automate my personal nix home configuration setup made to work on Mac, NixOS, WSL2 and most Linux distributions.
## Usage

#### Download and run the setup scripts with the following command:

```cd / && mkdir nix-config-setup && cd $_ && curl https://raw.githubusercontent.com/greatwillow/nix-config-setup/main/0-run-setup.sh -O && source 0-run-setup.sh```

## Context

#### Logic of the setup scripts:

##### 1-setup-user.sh

- Ensures that the currently logged in user is not the root user.  Only non-root users are able to install packages using Nix.  
- If the current user is the root user, a prompt is added to allow either for a new user to be created and used, or another user to be selected.
- Once a non root user has been selected, the script logs the shell into the system as that user.
  
##### 2-install-nix.sh
- This script will install Nix which is used for package management across platforms including different Linux distributions, MacOS and WSL.  Upon installing Nix, the user shell is restarted.  The output here will show an additional command that should be executed to run the final script below.

##### 3-install-nix-config.sh
- This script automates the download and installation of the desired nix-config setup.
