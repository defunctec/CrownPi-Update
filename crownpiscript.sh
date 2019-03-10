#!/bin/bash

# Clear Screen
clear_screen() {
     clear   
     sleep 3
     echo CrownPi is now updating...
     sleep 2
}

# Update OS
update_repos() {
    echo Updateing OS, please wait...
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
}

# Download Crown client (Update link with new client)
download_package() {
    # Password change prompt
    echo Getting 0.12.7.3
    # Create temporary directory
    dir=`mktemp -d`
    if [ -z "$dir" ]; then
        # Create directory under $HOME if above operation failed
        dir=$HOME/crown-temp
        mkdir -p $dir
    fi
    # Change this later to take latest release version.
    sudo wget "https://gitlab.crown.tech/crown/crown-core/-/jobs/5409/artifacts/download" -O $dir/crown.zip
}

# Install Crown client
install_package() {
    echo Installing Crown client...
    sudo unzip -d $dir/crown $dir/crown.zip
    sudo cp -f $dir/crown/*/bin/* /usr/local/bin/
    sudo cp -f $dir/crown/*/lib/* /usr/local/lib/
    sudo rm -rf $tmp
}

# CrownPi package
main() {
    # Clear screen
    clear_screen
    # Stop crownd (in case it's running)
    sudo crown-cli stop
    # Update Repos
    update_repos
    # Install Packages
    download_package
    # Extract and install
    install_package
}

main

# Notes
echo Please use "sudo crownd" to start the client.