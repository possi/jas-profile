# jas
case "$TERM" in
    dumb)
        # Do not source .profile for X-Displays
        return
    ;;
    xterm*)
        if [ "$COLORTERM" = "xfce4-terminal" ]; then
            export TERM=xterm-256color
        fi
    ;;
esac

export HISTSIZE=2000
for l in en_US.utf8 en_US.UTF-8 en_US C; do
    if (locale -a | grep "^${l}$" > /dev/null); then
        export LANGUAGE="$l"
        break
    fi
done
if [ "$LC_ALL" = "" ]; then
    if (locale -a | grep C.UTF-8 > /dev/null); then
        export LC_ALL="C.UTF-8"
    fi
fi
if [ "$LANG" = "" ]; then
    export LANG="en_US.UTF-8"
fi

if [ "$(uname)" = "Darwin" ]; then
    alias ll='ls -l'
    alias l='ls -alh'
else
    export LS_OPTIONS='--color=auto'
    eval `dircolors`
    alias ls='ls $LS_OPTIONS'
    alias ll='ls $LS_OPTIONS -l'
    alias l='ls $LS_OPTIONS -alh'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cd..='cd ..'
alias c='cd -P'

alias rmd='rmdir'
alias md='mkdir -p'
alias untar='tar -xf'

alias s='screen'
alias sl='screen -ls'
alias sr='screen -r'

alias dus='du -h -s *'
alias du.='du -h -s `pwd -P`'
alias du='du -h'
alias df='df -h'

alias wl='wc -l'
alias note="cat <<'' >> ~/note;echo '-----------------------------------' >> ~/note"
alias cal='cal -m'
alias cgrep='grep --color=always'

alias rmx='rm -rf'

alias defchmod664='chmod -R 664 . && find . -type d -exec chmod a+x {} \;'
alias defchmod644='chmod -R 644 . && find . -type d -exec chmod a+x {} \;'

alias wget="wget --trust-server-names"
alias vi='vim'
export EDITOR='/usr/bin/vim'

if [ ! -z "$WINDIR" ]; then
    alias explorer-here='if [ -z "$1" ]; then explorer.exe /e,`cygpath -w "$PWD"`; else explorer.exe /e,`cygpath -w "$1"`; fi; true'
fi

d="$HOME/.config/jas-profile"
alias jas-profile="$HOME/.config/jas-profile/setup.sh"

if [ -f "$HOME/.ssh/id_dsa" ] || [ -f "$HOME/.ssh/id_rsa" ]; then
    . ${d}/.ssh_agent
fi

h="$(hostname)"
if [ -n "$1" ]; then
    s="$1"
else
    #s="$(basename $SHELL)"
    s="$0"
fi
test -f ${d}/.profile.${h} && . ${d}/.profile.${h}
test -f ${d}/.profile.${s} && . ${d}/.profile.${s}
test -f ${d}/.profile.${h}.${s} && . ${d}/.profile.${h}.${s}
true
