# (MrM) This should always be at the start of the file
# (MrM) Uncomment this as well as the last line of this file to start zsh with startup
# (MrM) profiler
#zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="agnoster"
#
# Powerline go used instead - see https://github.com/justjanne/powerline-go
function powerline_precmd() {
    PS1="$(~/go/bin/powerline-go \
		-hostname-only-if-ssh \
		-ignore-repos "$HOME" \
		-modules "venv,user,host,ssh,cwd,perms,git,hg,jobs,exit,root" \
		-max-width 100 \
		-error $? \
		-shell zsh \
		)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git tmux tmuxinator pip fasd)
# Also used at some point: autoenv zsh-auto-virtualenv virtualenvwrapper 

# User configuration

# Ensure history is shared on command execution
setopt INC_APPEND_HISTORY

# Path
export PATH=$PATH:"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/mrmino/.bin"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor & resource opener
export EDITOR='vim'
export OPENER='xdg-open'


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

export SSH_AUTH_SOCK=/run/user/$(id -u)/keyring/ssh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias nokiavpn="i3-msg \"exec ~/.bin/vpn\""
alias show_proxy="env | grep -i _proxy"
alias unproxy="unset \$(show_proxy | cut -d= -f1)"
#10.158.100.2
alias proxify="
export ftp_proxy=http://10.144.1.10:8080/
export http_proxy=http://10.144.1.10:8080/
export https_proxy=http://10.144.1.10:8080/

export no_proxy=\
localhost,127.0.0.0/8,*.local,\
nsn-net.net,\
inside.nokiasiemensnetworks.com,\
access.nokiasiemensnetworks.com,\
nsn-intra.net,\
nsn-rdnet.net,\
ext.net.nokia.com

export FTP_PROXY=$ftp_proxy
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export NO_PROXY=$no_proxy
"

alias chrome-noproxy="ftp_proxy= http_proxy= https_proxy= google-chrome & disown"

#Add $DEFAULT_USER, so zsh themes won't clutter up the prompt
DEFAULT_USER="mrmino"

# Add package suggestion feature
source /etc/zsh_command_not_found

# Add alias for fast piping into xclip clipboard
# Usage: somecommand | ctrlc
alias ctrlc='xclip -selection c'

# Alias for ~/.bin/git-vim
alias gv='git vim'

# Path to directory where scripts reside
SCRIPT_BIN=~/.bin

# Fuzzy finder initialization.
source $SCRIPT_BIN/fzf.zsh

# Calculator
'='(){
    calc="$@"
    # Uncomment the below for (p → +) and (x → *)
    # calc="${calc//p/+}"
    calc="${calc//x/*}"
    echo -e "$calc\nquit"| gcalccmd | sed "s:^> ::g"
}

# Required on Fedora / RedHat for many features
# Alias vim into extended vim
#alias vim='vimx'

# Always open less with pygmentize
export LESSOPEN='|pygmentize %s'
# Pygmentized cat
alias pcat='pygmentize -O style=monokai -f terminal -g'

# Disable rm 
#alias rm='echo "rm is disabled, use trash or /bin/rm instead."'

# Virtualenvwrapper support
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/
export VIRTUALENVWRAPPER_WORKON_CD=no
source /usr/local/bin/virtualenvwrapper_lazy.sh

# ZSH syntax highliting - keep this always at the end (before zprof)
source $SCRIPT_BIN/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Make python>=3.7 run ipdb at breakpoint()
export PYTHONBREAKPOINT=ipdb.set_trace

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Fast test output window setup
alias pyentr="find . -name '*.py' | entr -cn"
function pyte {
    breakpoint="PYTHONBREAKPOINT=pdb.set_trace"
    tmux split-window -e $breakpoint -h "find . -iname '*.py' | entr -c pytest -s"
    tmux split-window "find . -iname '*.py' | entr -cn mypy **/*.py"
}

# (MrM) This should be always at the end.
# (MrM) Uncomment this as well as the first line in this file to use startup 
# (MrM) profiler
#zprof
