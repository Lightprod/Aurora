#!/bin/bash

set -ouex pipefail

log() { # from AmyOS's build files
  echo "=== $* ==="
}

display() {
    echo ""
    echo "============= Content of $* ==============="
    cat $*
    echo "==========================================
    "
}

set -ouex pipefail

log "Building image"


# ======================================================================================
# Defining variables

# REMOVE_PACKAGES=(
    # "sddm" # Not needed in F44
# )

ADD_PACKAGES_FEDORA_REPO=(
    "gvfs-smb"
    "atuin"
    "gparted"
    "plasma-login-manager"
    "kvantum"
    "firefox"
    "firefox-langpacks"
    "firefoxpwa"
    "filebot"
    "zenity"
    "mediainfo"
    "steam"
    "steam-devices"
)


ADD_PACKAGES_TERRA_REPO=(
    "vesktop"
    "veracrypt"
    "codium"
)


# ======================================================================================
#  Remove uneeded packages from Kinoite

# log "Removing packages..."
    # dnf5 remove --no-autoremove -y ${REMOVE_PACKAGES[@]}

# ======================================================================================
#  Enable fedora-multimedia repo

log "Enabling fedora-multimedia..."
    # sed -i 's@enabled=0@enabled=1@g' "/etc/yum.repos.d/fedora-multimedia.repo"
    dnf5 -y config-manager setopt fedora-multimedia.enabled=1

# ======================================================================================
#  Install Terra repo

log "Installing terra repo..."
    dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# ======================================================================================
#  Install packages from fedora repos

log "Installing packages from fedora repos..."
    dnf5 install -y ${ADD_PACKAGES_FEDORA_REPO[@]} 

# ======================================================================================
#  Install packages from terra repos

log "Installing packages from Terra..."
    # dnf5 install --setopt install_weak_deps=False -y ${ADD_PACKAGES_TERRA_REPO[@]}
    dnf5 install -y ${ADD_PACKAGES_TERRA_REPO[@]}

# ======================================================================================
#  Enable wallpaper-engine-kde-plugin COPR Repo and install it

log "Enabling wallpaper-engine-kde-plugin repo..."

    dnf5 copr enable -y "jackgreiner/wallpaper-engine-kde-plugin"

log "Installing wallpaper-engine-kde-plugi"

    dnf5 install --skip-broken --skip-unavailable -y "wallpaper-engine-kde-plugin"

# ====================================================================
# Enable plasma login manager

# systemctl enable plasmalogin.service

log "Cleaning up dnf5..."

dnf5 clean all

log "Done"
