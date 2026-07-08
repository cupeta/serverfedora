#!/bin/bash

set -ouex pipefail

## DNF5 Speedup
sed -i '/^\[main\]/a max_parallel_downloads=10' /etc/dnf/dnf.conf

### set up opt for extra apps
mkdir /opt/bin
#add extra/bin path to system-wide bashrc and etc/profile
echo 'export PATH="$PATH:/opt/bin"' | tee -a /etc/bash.bashrc
echo 'export PATH="$PATH:/opt/bin"' |  tee /etc/profile.d/opt_bin.sh
chmod +x /etc/profile.d/opt_bin.sh

# install fuse2 libs for some AppImages to work
dnf -y install fuse-libs

dnf -y install libreoffice

#HYPRLAND
bash /ctx/hyprland.sh

#waybar
dnf -y install waybar

#power managment
dnf -y install power-profiles-daemon  --allowerasing

# fully-featured ffmpeg & OBS with nonfree components from rpm fusion (from morrolinux/morros)
dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf -y install ffmpeg x264-libs obs-studio obs-studio-plugin-x264 --allowerasing

#gtk customization tool
dnf -y install nwg-look

#install tailscale
dnf -y install tailscale

#installing cifs-utils for samba mounts
dnf -y install cifs-utils

#nvtop for monitoring nvidia gpu
dnf -y install nvtop

#ark for opening archives
dnf -y install  ark 7zip unrar

#various desktop apps
dnf -y install ghostty firefox telegram-desktop easyeffects qpwgraph wofi pcmanfm vlc inkscape gimp galculator homebank

#GAMES
# packages copied from rakuos setup-gaming
dnf -y install steam lutris heroic-games-launcher lact goverlay mangohud mangohud.i686 protonplus protontricks vkBasalt vkBasalt.i686
#prismlauncher for Minecraft
dnf -y install prismlauncher

#sunshine
dnf copr enable -y lizardbyte/stable
dnf -y install sunshine

#moonlight
bash /ctx/moonlight.sh

#kmonad for keyboard macros
dnf -y install kmonad

### MUSIC
dnf -y copr enable ycollet/audinux
#fix for apps loking for libjack.so in /usr/lib64
ln -s /usr/lib64/pipewire-0.3/jack/libjack.so.0 /usr/lib64/libjack.so
#libraries for some lv2\clap plugins to work
dnf -y install juce zenity
#DAW plugins
dnf -y install sfizz-ui guitarix lsp-plugins
##install Musescore
bash /ctx/musescore.sh
##install Reaper
bash /ctx/reaper.sh
#install shoopdaloop
bash /ctx/shoopdaloop.sh

#setup lua (RakuOS seems to force overlay install for luarocks...?)
#bash /ctx/lua.sh

#cosign for OCI image signing
bash /ctx/cosign.sh

#install ly greeter
bash /ctx/ly.sh

#### enable systemd units
systemctl enable podman.socket
systemctl enable tailscaled

# Clean up dnf cache to reduce image size
dnf -y clean all
#rm -rf /run/dnf /run/selinux-policy
#rm -rf /var/lib/dnf

### Install packages
# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
#https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
