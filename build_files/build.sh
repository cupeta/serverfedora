#!/bin/bash

set -ouex pipefail

# dnf speedup
sed -i '/^\[main\]/a max_parallel_downloads=10' /etc/dnf/dnf.conf
# set up custom /opt/bin folder for extra apps (non-dnf software,like AppImages)
mkdir /opt/bin
# add /opt/bin path to system-wide bashrc and etc/profile
echo 'export PATH="$PATH:/opt/bin"' | tee -a /etc/bash.bashrc
echo 'export PATH="$PATH:/opt/bin"' |  tee /etc/profile.d/opt-bin_path.sh
chmod +x /etc/profile.d/opt-bin_path.sh

# SYSTEM APPS
# fuse2 libs for some AppImages to work correctly
dnf -y install fuse-libs
# power settings\battery managment for laptops
dnf -y install power-profiles-daemon  --allowerasing
# cifs-utils for samba mounts
dnf -y install cifs-utils
# Tailscale for private vpn
dnf -y install tailscale

# nvtop for monitoring nvidia gpu
dnf -y install nvtop

# DESKTOP ENVIRONMENT
# ly greeter
bash /ctx/ly.sh
# Hyprland window manager
bash /ctx/hyprland.sh
# waybar
dnf -y install waybar
# wofi (menu and app launcher)
dnf -y install wofi
# gtk customization tool
dnf -y install nwg-look

# DESKTOP APPS
# terminal
dnf -y ghostty
# file manager
dnf -y install pcmanfm
# ark for opening archives
dnf -y install ark 7zip unrar
# web browser
dnf -y install firefox
# audio utils
dnf -y install qpwgraph easyeffects vlc
# office & productiviy
dnf -y install libreoffice homebank galculator telegram-desktop
# graphic design & photo editing
dnf -y install inkscape gimp
# kmonad for keyboard macros
dnf -y install kmonad

# REMOTE DEKSTOP
# Sunshine (server)
dnf copr enable -y lizardbyte/stable
dnf -y install sunshine
# Moonlight (client)
bash /ctx/moonlight.sh

# CODING & DEV TOOLS
# setup lua (RakuOS seems to force overlay install for luarocks...?)
# bash /ctx/lua.sh
# cosign for OCI image signing
bash /ctx/cosign.sh

# MUSIC PRODUCTION
# ycollect/audinux repo with many audio plugins
dnf -y copr enable ycollet/audinux
# fix for apps loking for libjack.so in /usr/lib64
ln -s /usr/lib64/pipewire-0.3/jack/libjack.so.0 /usr/lib64/libjack.so
# libraries for some lv2\clap plugins to work
dnf -y install juce zenity
# DAW plugins
dnf -y install sfizz-ui guitarix lsp-plugins
# install Musescore music sheet editor
bash /ctx/musescore.sh
# install Reaper
bash /ctx/reaper.sh
# install shoopdaloop looper
bash /ctx/shoopdaloop.sh

# VIDEO EDITING
#f ully-featured ffmpeg & OBS with nonfree components from rpm fusion (from morrolinux/morros)
dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf -y install ffmpeg x264-libs obs-studio obs-studio-plugin-x264 --allowerasing

# GAMING
# packages copied from rakuos setup-gaming
dnf -y install steam lutris heroic-games-launcher lact goverlay mangohud mangohud.i686 protonplus protontricks vkBasalt vkBasalt.i686
# Prismlauncher for Minecraft
dnf -y install prismlauncher

#POST INSTALL
# enable systemd units
systemctl enable podman.socket
systemctl enable tailscaled
# clean up dnf cache to reduce image size
dnf -y clean all
rm -rf /run/dnf /run/selinux-policy
rm -rf /var/lib/dnf

############################
# Install packages
# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
#https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# Use a COPR Example:

# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
