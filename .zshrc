# Path to your oh-my-zsh installation.
export ZSH=/home/mrmino/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

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
# COMPLETION_WAITING_DOTS="true"

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
plugins=(git virtualenv tmux tmuxinator pip zsh-syntax-highlighting)
# Also used at some point: autoenv zsh-auto-virtualenv virtualenvwrapper 

# User configuration

  export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#~~~ZPLUG~~~
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "junegunn/fzf-bin", \
	from:gh-r, \
	as:command, \
	rename-to:fzf, \
	use:"*darwin*amd64*"
zplug "b4b4r07/enhancd", use:init.sh


zplug "plugins/git", from:oh-my-zsh
zplug "plugins/virtualenv", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/tmuxinator", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/zsh-syntax-highlighting", from:oh-my-zsh

#-----------
zplug load 
#~~~~~~~~~~~

#Add $DEFAULT_USER, so zsh themes won't clutter up the prompt
DEFAULT_USER="mrmino"

# Add package suggestion feature
. /etc/zsh_command_not_found

# Add alias for fast piping into 'ctrl+c ctrl+v' clipboard
# Usage: somecommand | ctrlc
alias ctrlc='xclip -selection c'

# Switch to ls++
# https://github.com/trapd00r/ls--
alias ls='ls++'
alias lsls='/bin/ls --color=tty'

# Fuzzy finder initialization.
source ~/.fzf.zsh

# Initialize Z (https://github.com/rupa/z) 
source ~/.z-bin/z.sh 

# Calculator
'='(){
    calc="$@"
    # Uncomment the below for (p → +) and (x → *)
    # calc="${calc//p/+}"
    calc="${calc//x/*}"
    echo -e "$calc\nquit"| gcalccmd | sed "s:^> ::g"
}

# Pygmentized cat
alias pcat='pygmentize -O style=monokai -f terminal -g'

# Required on Fedora / RedHat for many features
# Alias vim into extended vim
#alias vim='vimx'

# Add ~/bin to path
export PATH=$PATH:~/bin

# Always open less with pygmentize
export LESSOPEN='|pygmentize %s'

# Better do it before something goes terribly wrong
# Disable rm 
alias rm='echo "rm is disabled, use trash or /bin/rm instead."'

# Aliasses for easier pip management
alias spip='sudo -H pip'
alias upip='pip --user'
alias spip3='sudo -H pip3'
alias upip3='pip3 --user'

# Virtualenvwrapper support
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/
source /usr/local/bin/virtualenvwrapper.sh

# Enhanced cd
export ENHANCD_FILTER=fzf
alias -g ...=...
export ENHANCD_DOT_ARG=...
