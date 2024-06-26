# Path to your oh-my-zsh installation.
export ZSH_CUSTOM=$HOME/.config/jas-profile/.zsh-custom
export ZSH=$HOME/.config/jas-profile/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo-nogit"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

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

# https://github.com/ohmyzsh/ohmyzsh/issues/8128#issuecomment-530387945
# DISABLE_MAGIC_FUNCTIONS=true

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast git-flow sudo redis-cli screen symfony2 cp ubuntu yarn vagrant)

# User configuration
if [ -e $HOME/.config/jas-profile/.zshrc.local ]; then
    source $HOME/.config/jas-profile/.zshrc.local;
fi
if [ -e $HOME/.zshrc.local ]; then
    source $HOME/.zshrc.local;
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
source $ZSH/../.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

if [ "/bin/bash" = "$SHELL" ]; then
    export SHELL=`which zsh`
fi

## Startup-Time DEBUG
#zmodload zsh/zprof
#PS4='+ $(date "+%s.%N")\\011 '
#set -x

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $HOME/.config/jas-profile/.profile zsh

## Startup-Time DEBUG
#set +x
#zprof

# bun completions
if [ -s "/home/starke/.bun/_bun" ]; then
   source "/home/starke/.bun/_bun"

    # bun
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

if which zoxide 2>&1 >/dev/null; then
    #eval "$(zoxide init --cmd cd zsh)"

    _z_cd() {
        builtin cd "$@" || return "$?"

        if [ "$_ZO_ECHO" = "1" ]; then
            echo "$PWD"
        fi
    }

    cd() {
        if [ "$#" -eq 0 ]; then
            _z_cd ~
        elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
            if [ -n "$OLDPWD" ]; then
                _z_cd "$OLDPWD"
            else
                echo 'zoxide: $OLDPWD is not set'
                return 1
            fi
        else
            _zoxide_result="$(zoxide query -- "$@")" && _z_cd "$_zoxide_result"
        fi
    }

    cdi() {
        _zoxide_result="$(zoxide query -i -- "$@")" && _z_cd "$_zoxide_result"
    }


    alias cda='zoxide add'

    alias cdq='zoxide query'
    alias cdqi='zoxide query -i'

    alias cdr='zoxide remove'
    cdri() {
        _zoxide_result="$(zoxide query -i -- "$@")" && zoxide remove "$_zoxide_result"
    }


    _zoxide_hook() {
        zoxide add "$(pwd -L)"
    }

    chpwd_functions=(${chpwd_functions[@]} "_zoxide_hook")
fi 

# pnpm
export PNPM_HOME="/home/starke/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
