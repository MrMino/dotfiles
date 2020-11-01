#!/bin/bash

LOG_DIR=$(mktemp -d --suffix=postlog)
LOG_PATH=$LOG_DIR/postlog
DOTFILES_REPO_URL=https://github.com/MrMino/dotfiles.git
VIM_COLORSCHEME_URL=https://raw.githubusercontent.com/MrMino/dotfiles/vim/.vim/colors/brighton_modified.vim

function log_msg {
    echo -e $@ >> $LOG_PATH
    echo -e $@
}

function install_pkg {
    log_msg -n "Installing \"$1\".."
    if ! apt install --yes $@ &>> $LOG_PATH; then
        log_msg "Error: apt install failed."
        exit 3
    fi
    log_msg ". Done."
}

function install_pip3_pkg {
    log_msg -n "Installing (via pip3) \"$1\".."
    if ! python3 -m pip install -vvv $@ &>> $LOG_PATH; then
        log_msg "Error: pip3 install failed."
        exit 9
    fi
    log_msg ". Done."
}

function do_update_upgrade {
    log_msg "Running update/upgrade"
    apt update --yes &>> $LOG_PATH
    apt upgrade --yes &>> $LOG_PATH
}

function do_sanity_checks {
    if ! ping 8.8.8.8 -c 1 &>> $LOG_PATH; then
        log_msg "Error: network seems to be unavailable."
        exit -1
    fi
    if [[ $EUID -ne 0 ]]; then
        log_msg "Error: this script must be run as root."
        exit 1
    fi

    if ! which apt > /dev/null 2>&1; then
        log_msg "Error: apt not found."
        exit 2
    fi

    #TODO should also check for python
}

function do_broadcom_card_setup {
    log_msg
    log_msg "Checking for broadcom wireless card."
    update-pciids &>> $LOG_PATH
    if [[ `lspci -nn -d 14e4:` ]]; then
        log_msg "Detected broadcom card - checking PCI ID."
        read -a lspci_otp <<<"$(lspci -mn -d 14e4:)"
        pci_id=$(log_msg ${lspci_otp[3]} | tr --delete '\"')
        log_msg "Detected PCI ID: $pci_id"

        if [[ $pci_id == 4365 ]]; then
            log_msg "Downloading drivers."
            install_pkg bcmwl-kernel-source
        else
            log_msg "Warning: I don't recognize this card - skipping."
        fi
    else
       log_msg "Broadcom wireless card not detected."
    fi
    log_msg
}

function do_pip2n3_upgrade {
    log_msg
    log_msg "Upgrading pip and pip3 to latest versions."
    if ! pip2 install --upgrade pip &>>$LOG_PATH; then
        log_msg "Error: pip2 upgrade failed."
        exit 5
    fi
    if ! pip3 install --upgrade pip &>>$LOG_PATH; then
        log_msg "Error: pip3 upgrade failed."
        exit 6
    fi
}

function do_tmux_chsh {
    log_msg
    log_msg "Configuring default shell."

    current_user=$(logname)

    current_shell=$(grep $current_user /etc/passwd | cut -d: -f7)
    if [[ $current_shell == tmux ]]; then
        log_msg "Current shell is already tmux - skipping."
        return 0
    fi

    log_msg "Current default shell: \"$current_shell\"."

    tmux_path=$(which tmux)
    if [[ $tmux_path != /usr/bin/tmux ]]; then
        log_msg "Error: tmux is not in \"/usr/bin/tmux\""
	exit 3
    fi

    log_msg "Changing the default shell of $current_user to \"$tmux_path\"."
    sudo usermod --shell $tmux_path $current_user &>> $LOG_PATH
}

function do_make_i3_default {
    log_msg "Making i3wm the default session manager."
    session_file=/var/lib/AccountsService/users/$SUDO_USER

	if [ ! -f $session_file ]; then
        log_msg "Error: session file not found."
        exit 20
    fi

    sed -i 's/XSession=.*/XSession=i3/' $session_file
}

function add_external_apt_keys_and_repos {
	log_msg "Downloading & adding apt keys."
	wget -q -O - https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	wget -q -O - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	log_msg "Adding apt repos for proprietary apps."
	echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
	echo "deb https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/ms-teams.list
	echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker-io.list
}

# Empty, chown the logs
echo "LOGGING TO $LOG_PATH"
echo > $LOG_PATH
chmod -R 777 $LOG_DIR
chown -R $SUDO_USER $LOG_DIR

add_external_apt_keys_and_repos
do_sanity_checks
do_update_upgrade
do_broadcom_card_setup

install_pkg python3-pip
install_pkg python-dev
install_pkg python3-dev
install_pkg python-pip
do_pip2n3_upgrade

install_pkg git
install_pkg curl
install_pkg vim-gtk3
install_pkg zsh
install_pkg tmux
install_pkg cmake
install_pkg build-essential
install_pkg tree
# install_pkg swi-prolog
install_pkg xclip
install_pkg trash-cli
install_pkg i3
install_pkg rofi
install_pkg feh
install_pkg conky
install_pkg compton
install_pkg i3blocks
install_pkg cmus
# Only installs powerline fallback - not patched fonts
install_pkg fonts-powerline
install_pkg fonts-font-awesome
install_pkg build-essential
install_pkg htop
install_pkg xdotool
install_pkg gparted
install_pkg entr
install_pkg dos2unix
install_pkg cifs-utils
install_pkg vagrant
install_pkg pavucontrol
install_pkg zeal

# Proprietary stuff + packages supporting that
install_pkg teams
install_pkg spotify-client
install_pkg google-chrome-stable
install_pkg containerd.io
install_pkg docker-ce
install_pkg docker-ce-cli

install_pip3_pkg virtualenv
install_pip3_pkg virtualenvwrapper
install_pip3_pkg ipython
install_pip3_pkg ipdb
install_pip3_pkg flake8
install_pip3_pkg pygments
install_pip3_pkg powerline-status
install_pip3_pkg ansible


do_make_i3_default

timedatectl set-local-rtc 1 --adjust-system-clock &>> $LOG_PATH

# Get back from root privileges - we dont want to populate home
# with root owned files.
sudo -u $SUDO_USER ./_no_sudo.sh $LOG_PATH

do_tmux_chsh
