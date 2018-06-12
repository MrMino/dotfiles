# (MrM) This should always be at the start of the file
# (MrM) Uncomment this as well as the last line of this file to start zsh with startup
# (MrM) profiler
zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

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
plugins=(git tmux tmuxinator pip zsh-autosuggestions)
# Also used at some point: autoenv zsh-auto-virtualenv virtualenvwrapper 

# User configuration

# Path
export PATH=$PATH:"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

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

#Add $DEFAULT_USER, so zsh themes won't clutter up the prompt
DEFAULT_USER="mrmino"

# Add package suggestion feature
source /etc/zsh_command_not_found

# Add alias for fast piping into xclip clipboard
# Usage: somecommand | ctrlc
alias ctrlc='xclip -selection c'


# Path to directory where scripts reside
SCRIPT_BIN=~/.bin

# Fuzzy finder initialization.
source $SCRIPT_BIN/fzf.zsh

# Initialize Z (https://github.com/rupa/z) 
source $SCRIPT_BIN/z/z.sh
# autoload z

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
source /usr/local/bin/virtualenvwrapper_lazy.sh

# ZSH syntax highliting - keep this always at the end (before zprof)
source $SCRIPT_BIN/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# (MrM) This should be always at the end.
# (MrM) Uncomment this as well as the first line in this file to use startup 
# (MrM) profiler
#zprof
