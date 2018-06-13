#!/bin/bash

LOG_PATH=$1
DOTFILES_REPO_URL=https://github.com/MrMino/dotfiles.git
VIM_COLORSCHEME_URL=https://raw.githubusercontent.com/MrMino/dotfiles/vim/.vim/colors/brighton_modified.vim

function log_msg {
    echo -e $@ >> $LOG_PATH
    echo -e $@
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
    oh_my_zsh_script="$(echo "$oh_my_zsh_script" | sed '/env zsh/d' | \
	    sed '/chsh -s/d')"
    echo "$oh_my_zsh_script" &>> $LOG_PATH

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
    if ! wget --directory-prefix=$colorscheme_dir $VIM_COLORSCHEME_URL\
            &>> $LOG_PATH ; then
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
        log_msg "Download done."
    fi
}

function do_tpm_plugin_install {
	log_msg "Installing tmux plugins via tpm."
    if ! ~/.tmux/plugins/tpm/scripts/install_plugins.sh &>>$LOG_PATH; then
        log_msg "Plugin installation failed."
        exit 8
    fi
    log_msg "Plugin installation done."
    log_msg
}

function download_dotfiles {
	log_msg
	dotfiles_dir=/tmp/dotfiles
    if [ -d $dotfiles_dir ]; then
		log_msg "Dotfiles dir (\"$dotfiles_dir\") already exists."
		log_msg "Removing"
		rm -rf $dotfiles_dir
	fi

	log_msg "Downloading dotfiles to \"$dotfiles_dir\"."
	if ! git clone $DOTFILES_REPO_URL $dotfiles_dir \
			--branch unify &>> $LOG_PATH
	then
		log_msg "Failed to clone dotfiles repository."
		exit 21
	fi

	log_msg "Moving dotfiles to the home directory."
	mv $dotfiles_dir/.i3 ~/.i3 -f &>> $LOG_PATH
	mv $dotfiles_dir/.zshrc ~/.zshrc &>> $LOG_PATH
	mv $dotfiles_dir/.vimrc ~/.vimrc &>> $LOG_PATH
	mv $dotfiles_dir/.tmux.conf ~/.tmux.conf &>> $LOG_PATH
	mv $dotfiles_dir/.git ~/.git -f &>> $LOG_PATH
	mv $dotfiles_dir/.gitignore ~/.gitignore &>> $LOG_PATH
	mv $dotfiles_dir/.gitconfig ~/.gitconfig &>> $LOG_PATH
}

cd ~

do_oh_my_zsh
download_dotfiles

do_vundle_install
do_vim_colorscheme_install
do_vim_plugin_install
do_ycm_install
do_tmux_tpm

# Reload config, for tpm.
tmux source-file ~/.tmux.conf
do_tpm_plugin_install

do_home_bin_dir
do_gdsf_install
do_gdsf_config
do_fzf_install
do_z_install
do_zshsh_install