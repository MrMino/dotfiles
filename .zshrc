# Path to your oh-my-zsh installation.
  export ZSH=/home/MrMino/.oh-my-zsh

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
plugins=(git virtualenv virtualenvwrapper tmux tmuxinator pip autoenv zsh-auto-virtualenv)

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


#--- ADD BY MRMINO ---
#Add $DEFAULT_USER, so zsh themes won't clutter up the prompt
DEFAULT_USER="MrMino"


#Add package suggestion feature
# . /etc/zsh_command_not_found

#Add my own script directory. For reasons.
PATH=${PATH}:~/bash_scripts

#Add alias for fast piping into 'ctrl+c ctrl+v' clipboard
#somecommand | ctrlc
alias ctrlc='xclip -selection c'

#I need that stack overflow badge and I'm willing to do anyhing to get it!
#google-chrome http://stackoverflow.com & echo "Get that badge!"

#Fuzzy finder. Wonder when I'll actually start to use it :|
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#DISABLED: learning virtualenv, this has to go.
#Could it be that it breaks terminal plugin (ctrl+shift+t) in sublime text O_o? -- No.
#OpenCV is a bitch to install, I tell ya. This is for OpenCV in python3. IHNIWID. 
# virtualenv and virtualenvwrapper
#export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
#export WORKON_HOME=$HOME/.virtualenvs

#initialize Z (https://github.com/rupa/z) 
. ~/bin/z/z.sh 

#calculator
'='(){
    calc="$@"
    # Uncomment the below for (p → +) and (x → *)
    #calc="${calc//p/+}"
    #calc="${calc//x/*}"
    echo -e "$calc\nquit"| gcalccmd | sed "s:^> ::g"
}

#ZSH Syntax highlighting plugin
source /home/MrMino/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#Autoenv
source ~/.autoenv/activate.sh

#Pygmentized cat
alias pcat='pygmentize -O style=monokai -f terminal -g'

alias vim='vimx'
