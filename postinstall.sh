#!/bin/bash

LOG_PATH=/tmp/postlog
DOTFILES_REPO_URL=https://github.com/MrMino/dotfiles.git

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
    if ! pip install $@ &>> $LOG_PATH; then
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
    if ! pip install --upgrade pip &>>$LOG_PATH; then
        log_msg "Error: pip2 upgrade failed."
        exit 5
    fi
    if !pip3 install --upgrade pip &>>$LOG_PATH; then
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

function do_tmux_tpm {
    log_msg
    log_msg "Installing tmux plugin manager (TPM)."
    tpm_dir=~/.tmux/plugins/tpm
    if [ -d $tpm_dir ]; then
        log_msg "TPM directory (\"$tpm_dir\") already exists. Skipping."
	return 0
    elif ! git clone https://github.com/tmux-plugins/tpm $tpm_dir &>>$LOG_PATH; then
        log_msg "Error: TPM downloading failed." 
        exit 7
    else
        log_msg "Download done, running plugin installation."
    fi

    if ! ~/.tmux/plugins/tpm/scripts/install_plugins.sh &>>$LOG_PATH; then
        log_msg "Plugin installation failed."
        exit 8
    fi
    log_msg "Plugin installation done."
    log_msg
}

function do_oh_my_zsh {
    log_msg "Instaling oh-my-zsh."
    install_url=https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh


    if ! oh_my_zsh_script="$(curl -fsSL $install_url)"; then
	log_msg "Error: cannot download oh-my-zsh install script."
        exit 11
    fi

    # Make sure we're not running something else
    expected_md5="705b585ae28274e36a8bb359c19a8efe  -"
    if [ "$(echo $oh_my_zsh_script | md5sum)" = "$expected_md5" ]
    then
        log_msg "Error: oh-my-zsh install script: wrong MD5 sum."
        exit 12
    else
        log_msg "MD5 sum correct."
    fi

    # Make the install script *not* run zsh at the end.
    oh_my_zsh_script="$(echo "$oh_my_zsh_script" | sed '/env zsh/d')"

    if ! sh -c "$oh_my_zsh_script" &>> $LOG_PATH
    then
        log_msg "Error: oh-my-zsh installation failed."
        exit 9
    fi
    log_msg "Removing \".zshrc.pre-oh-my-zsh\"."
    rm ".zshrc.pre-oh-my-zsh" &>> $LOG_PATH
    log_msg "Oh-my-zsh Installation done."
}

function do_home_bin_dir {
    log_msg
    log_msg "Creating \"~/.bin\" directory."
    mkdir ~/.bin &>> $LOG_PATH
}

function do_fzf_install {
    fzf_dir=~/.bin/fzf
    fzf_url=https://github.com/junegunn/fzf.git

    log_msg "Installing fuzzy finder (FZF)."
    if [ -d $fzf_dir ]; then
        log_msg "FZF directory (\"$fzf_dir\") already exists. Skipping."
	return 0
    elif ! git clone $fzf_url $fzf_dir &>>$LOG_PATH; then
        log_msg "Error: FZF downloading failed." 
        exit 13
    else
        log_msg "Download done, running plugin installation."
    fi

    if ! $fzf_dir/install --no-bash --no-fish --key-bindings \
            --completion --no-update-rc &>>$LOG_PATH; then
        log_msg "Plugin installation failed."
        exit 14
    fi
    mv ~/.fzf.zsh ~/.bin/fzf.zsh
    log_msg "Plugin installation done."
}

function do_z_install {
    z_dir=~/.bin/z
    z_url=https://github.com/rupa/z

    log_msg "Installing z-jump (Z)."
    if [ -d $z_dir ]; then
        log_msg "Z directory (\"$z_dir\") already exists. Skipping."
	return 0
    elif ! git clone $z_url $z_dir &>>$LOG_PATH; then
        log_msg "Error: Z downloading failed." 
        exit 15
    else
        log_msg "Finished downloading z-jump."
    fi
}

function do_zshsh_install {
    zshsh_url=https://github.com/zsh-users/zsh-syntax-highlighting.git
    zshsh_dir=~/.bin/zsh-syntax-highlighting
    log_msg "Installing zsh-syntax-highlighting."
    if [ -d $zshsh_dir ]; then
        log_msg "Zsh-syntax-highlighting directory (\"$zshsh_dir\") already exists. Skipping."
	return 0
    elif ! git clone $zshsh_url $zshsh_dir &>>$LOG_PATH; then
        log_msg "Error: zsh-syntax-highlighting downloading failed." 
        exit 16
    else
        log_msg "Finished downloading zsh-syntax-highlighting."
    fi
}

function do_vundle_install {
    vundle_url=https://github.com/VundleVim/Vundle.vim.git
    vundle_dir=~/.vim/bundle/Vundle.vim
    log_msg "Installing Vundle."
    if [ -d $vundle_dir ]; then
        log_msg "Vundle directory (\"$vundle_dir\") already exists. Skipping."
	return 0
    elif ! git clone $vundle_url $vundle_dir &>>$LOG_PATH; then
        log_msg "Error: Vundle downloading failed." 
        exit 16
    else
        log_msg "Finished downloading Vundle."
    fi
}

function do_vim_plugin_install {
    log_msg "Calling vim: PluginInstall."
    vim -c 'PluginInstall' -c 'q' -c 'q'
    log_msg "Done"
}

function do_ycm_install {
    ycm_path=~/.vim/bundle/YouCompleteMe/
	log_msg "Running YouCompleteMe install script."
	if ! $ycm_path/install.py --clang-completer &>> $LOG_PATH
    then
        log_msg "Error: YouCompleteMe installation failed."
		exit 17
    fi
	log_msg "YouCompleteMe installation done."
}

function do_vim_colorscheme_install {
	colorscheme_dir=~/.vim/colors
    log_msg "Installing vim color scheme."
    if ! wget --directory-prefix=$colorscheme_dir $VIMRC_URL &>> $LOG_PATH ; then
        log_msg "Error: downloading color scheme failed."
        exit 18
    fi
}

function do_gdsf_install {
	gdsf_url=https://github.com/so-fancy/diff-so-fancy
	gdsf_dir=~/.bin/git-diff-so-fancy
	log_msg "Installig git diff-so-fancy."
    if [ -d $gdsf_dir ]; then
        log_msg "Diff-so-fancy directory (\"$zshsh_dir\") already exists. Skipping."
	return 0
    elif ! git clone $gdsf_url $gdsf_dir &>>$LOG_PATH; then
        log_msg "Error: diff-so-fancy downloading failed."
        exit 19
    else
        log_msg "Finished downloading diff-so-fancy."
    fi
}

function do_gdsf_config {
	log_msg "Configuring git core.pager to diff-so-fancy."
	pager_conf="$gdsf_dir/diff-so-fancy | less --tabs=4 -RFX"
	git config --global core.pager "$pager_conf"
    git config --bool --global diff-so-fancy.markEmptyLines false
	log_msg
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

function download_dotfiles {
	log_msg
	dotfiles_dir=/tmp/dotfiles
    if [ -d $dotfiles_dir ]; then
		log_msg "Dotfiles dir (\"$dotfiles_dir\") already exists."
		log_msg "Updating the contents."
		cd $dotfiles_dir
        git pull &>> $LOG_PATH
		cd -
	else
		log_msg "Downloading dotfiles to \"$dotfiles_dir\"."
		if ! git clone $DOTFILES_REPO_URL $dotfiles_dir \
                --branch unify &>> $LOG_PATH
		then
			log_msg "Failed to clone dotfiles repository."
			exit 21
		fi
	fi

	log_msg "Moving dotfiles to the home directory."
	mv $dotfiles_dir/.* ~/
}

cd ~
do_sanity_checks
do_update_upgrade
do_broadcom_card_setup

install_pkg git
install_pkg curl
install_pkg vim-gtk3
install_pkg zsh
install_pkg tmux

install_pkg cmake
install_pkg build-essential

install_pkg python-pip
install_pkg python3-pip
install_pkg python-dev
install_pkg python3-dev
# install_pkg swi-prolog

do_pip2n3_upgrade
do_tmux_chsh
do_tmux_tpm

install_pip3_pkg powerline-status
install_pkg fonts-powerline

do_oh_my_zsh
do_home_bin_dir
do_fzf_install
do_z_install
do_zshsh_install

chown $SUDO_USER ~/.zsh_history

install_pkg xclip
install_pkg trash-cli
install_pip3_pkg virtualenv
install_pip3_pkg virtualenvwrapper
install_pip3_pkg ipython
install_pip3_pkg ipdb
install_pip3_pkg pygments

do_vim_colorscheme_install
do_vundle_install
do_vim_plugin_install
do_ycm_install
do_gdsf_install
do_gdsf_config

install_pkg i3
install_pkg rofi
install_pkg feh
install_pkg conky
install_pkg compton
install_pkg i3status
install_pkg cmus

do_make_i3_default
# do_install_blockscripts
