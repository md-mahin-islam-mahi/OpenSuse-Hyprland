#!/bin/bash

####### Hyprland Installation Script for OpenSuse #######
#                                                       #
#       ███╗   ███╗ █████╗ ██╗  ██╗██╗███╗   ██╗        #
#       ████╗ ████║██╔══██╗██║  ██║██║████╗  ██║        #
#       ██╔████╔██║███████║███████║██║██╔██╗ ██║        #
#       ██║╚██╔╝██║██╔══██║██╔══██║██║██║╚██╗██║        #
#       ██║ ╚═╝ ██║██║  ██║██║  ██║██║██║ ╚████║        #
#       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝        #
#                                                       #
#########################################################

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
megenta="\e[1;1;35m"
cyan="\e[1;36m"
end="\e[1;0m"

# initial texts
attention="${yellow}[ ATTENTION ]${end}"
action="${green}[ ACTION ]${end}"
note="${megenta}[ NOTE ]${end}"
done="${cyan}[ DONE ]${end}"
error="${red}[ ERROR ]${end}"

# Set the name of the log file
log="Install-logs/fonts.log"


fonts=(
fira-code-fonts
fontawesome-fonts
google-noto-sans-cjk-fonts
google-noto-color-emoji-fonts
google-noto-coloremoji-fonts
liberation-fonts
noto-sans-mono-fonts
symbols-only-nerd-fonts
xorg-x11-fonts-core
)


# install script dir
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/1-global.sh

other_font='extras/.fonts'

# Installation of main components
printf "${action} - Installing necessary fonts.... \n"

for PKG1 in "${fonts[@]}"; do
  install_package "$PKG1" "$log"
done

# jetbrains nerd font. Necessary for waybar
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
# Maximum number of download attempts
MAX_ATTEMPTS=2
for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
    curl -OL "$DOWNLOAD_URL" && break
    printf "Download attempt $ATTEMPT failed. Retrying in 2 seconds..."
    sleep 2
done

# Check if the JetBrainsMono folder exists and delete it if it does
if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
    rm -rf ~/.local/share/fonts/JetBrainsMonoNerd
fi

mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
# Extract the new files into the JetBrainsMono folder and log the output
tar -xJkf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd

# Update font cache and log the output
sudo fc-cache -fv 2>&1 | tee -a "$log"

# clean up 
if [ -d "JetBrainsMono.tar.xz" ]; then
	rm -r JetBrainsMono.tar.xz
fi

clear
