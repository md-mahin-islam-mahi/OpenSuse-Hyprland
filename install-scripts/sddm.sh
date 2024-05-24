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

# install script dir
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/1-global.sh

# Set the name of the log file
log="Install-Logs/sddm.log"

sddm_pkgs=(
  libqt5-qtgraphicaleffects
  libqt5-qtquickcontrols
  libqt5-qtquickcontrols2
  sddm-qt6
  xauth
  xf86-input-evdev
  xorg-x11-server
)

# Install SDDM 
printf "${action} - Installing sddm and dependencies.... \n"
for sddm in "${sddm_pkgs[@]}" ; do
  install_package_no_recommands "$sddm" "$log"
done

# Check if other login managers are installed and disabling their service before enabling sddm
for login_manager in lightdm gdm lxdm lxdm-gtk3; do
  if sudo  zypper se -i "$login_manager" &>> /dev/null; then
    printf "${attention} - $login_manager and ${green}SDDM${end} will be enabled...\n"
    sudo systemctl disable "$login_manager" 2>&1 | tee -a "$log"
  fi
done

# activation of sddm service
printf "${action} - Activating sddm service........\n"
sudo systemctl set-default graphical.target 2>&1 | tee -a "$log"
sudo update-alternatives --set default-displaymanager /usr/lib/X11/displaymanagers/sddm 2>&1 | tee -a "$log"
sudo systemctl enable sddm.service 2>&1 | tee -a "$log"

# setup wayland session
wayland_sessions_dir=/usr/share/wayland-sessions
if [ ! -d "$wayland_sessions_dir" ]; then
printf "${action} - $wayland_sessions_dir not found, creating...\n"
sudo mkdir -p "$wayland_sessions_dir" 2>&1 | tee -a "$log"
sudo cp extras/hyprland.desktop "$wayland_sessions_dir/" 2>&1 | tee -a "$log"
fi

# setting sddm theme
SDDM_THEME='extras/sddm-theme'
    printf "${action} - Setting up the login screen.\n"
    sudo cp -r $SDDM_THEME /usr/share/sddm/themes/
    sudo mkdir -p /etc/sddm.conf.d
    printf "[Theme]\nCurrent=sddm-theme\n" | sudo tee -a /etc/sddm.conf.d/10-theme.conf
    printf "${done} - Sddm theme installed.\n"
    printf "[ DONE ] - Sddm theme installed.\n"  2>&1 | tee -a "$log" &>> /dev/null

    sleep 1
