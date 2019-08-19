#!/bin/sh
# SCRIPT: install.sh
# PURPOSE: Install the IS_SiteLock plugin into cPanel
# AUTHOR: Ahmed Abdel Fattah <ahmedaas@gmail.com>
#
clear
echo "Installing IS_SiteLock..."

# Create the directory for the plugin
mkdir -p /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock

# Get the plugin files from Github

curl -s https://github.com/ahmed-aas/CpanelPlugin/raw/master/is_files.tar.gz > /root/is_files.tar.gz

# Uncompress the archive
tar xzf is_files.tar.gz

# Move files to /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock directory
mv /root/IS_SiteLock.live.pl /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock
mv /root/IS_SiteLock.tar.gz /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock

# Install the plugin (which also places the png image in the proper location)
/usr/local/cpanel/scripts/install_plugin /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock/IS_SiteLock.tar.gz

echo "Installation is complete!"

