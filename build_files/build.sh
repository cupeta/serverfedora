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
# cifs-utils for samba mounts
dnf -y install cifs-utils
# Tailscale for private vpn
dnf -y install tailscale


# CODING & DEV TOOLS
# setup lua (RakuOS seems to force overlay install for luarocks...?)
# bash /ctx/lua.sh
# cosign for OCI image signing
bash /ctx/cosign.sh

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
