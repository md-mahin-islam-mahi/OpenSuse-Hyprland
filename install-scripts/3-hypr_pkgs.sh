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
log="Install-Logs/hypr_pkgs.log"

# install script dir
ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/1-global.sh

# packages neeeded
hypr_package=( 
  curl
  git
  grim
  ImageMagick
  jq
  kitty
  kvantum-qt5
  kvantum-qt6
  kvantum-themes
  kvantum-manager
  libnotify-tools
  lxappearance
  make
  network-manager-applet
  neofetch
  neovim
  pamixer
  pavucontrol
  pipewire-alsa
  polkit-gnome
  python311-requests
  python311-pip
  python311-pywal
  qt5ct
  qt6ct
  qt6-svg-devel
  libqt5-qtquickcontrols
  libqt5-qtquickcontrols2
  libqt5-qtgraphicaleffects
  rofi-wayland
  slurp
  SwayNotificationCenter
  swappy
  swww
  tar
  unzip
  waybar
  wayland-protocols-devel
  wget
  wl-clipboard
  xdg-utils
  xwayland
  yad
)

hypr_package_2=(
  # brightnessctl
  btop
  cava
  mpv
  mpv-mpris
)

# opi
opi_packages=(
  swaylock-effects
  nwg-look
  wlogout
)

# no-recommends
thunar=(
ffmpegthumbnailer
file-roller
thunar 
thunar-volman 
tumbler 
thunar-plugin-archive
)

grimblast_url=https://github.com/hyprwm/contrib.git


# Installation of main components
printf "${action} - Installing hyprland packages.... \n"

for PKG1 in "${hypr_package[@]}" "${hypr_package_2[@]}"; do
  install_package "$PKG1" "$log"
done

# installing swaylock-effects & nwg-look
for opi_pkg in "${opi_packages[@]}"; do
  install_package_opi "$opi_pkg" "$log"
done

# installing thunar
for thunar in "${thunar[@]}"; do
  install_package_no_recommands "$thunar" "$log"
done

# installing grimblast
if [ -f '/usr/local/bin/grimblast' ]; then
  printf "${done} - Grimblast is already installed...\n"
  printf "[ DONE ] - Grimblast is already installed\n" 2>&1 | tee -a "$log" &>> /dev/null
else

  printf "${attention} - Cloning grimblast grom github to install for screenshot...\n"
  git clone --depth=1 "$grimblast_url" ~/grimblast
  cd "$HOME/grimblast/grimblast"
  make
  sudo make install

  sleep 1
  rm -rf ~/grimblast
  printf "${done} - Grimblast was installed successfully"
fi

# clear
