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

alias t='tmux'
alias ta='tmux attach'
alias tl='tmux ls'

alias _colors='for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ; if ! (( ($i + 1 ) % 8 )); then echo ; fi ; done'

#alias dus='du -h -s *'
alias dus='du -h -a -d 1 | sort --human-numeric-sort'
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
if [ "$(which vim 2>/dev/null)" != "" ]; then
    alias vi='vim'
    export EDITOR='/usr/bin/vim'
fi

alias gvs="find -type d -name '.git' -exec sh -c '(echo {} && cd {}/.. && git status -s && echo)' \\;"

export EDITOR='/usr/bin/vim'
export GIT_AUTHOR_NAME="Jascha Starke"
export GIT_COMMITTER_NAME="Jascha Starke"
export GIT_AUTHOR_EMAIL="j.starke@meeva.de"
export GIT_COMMITTER_EMAIL="j.starke@meeva.de"

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
if [ "-" = "${s:0:1}" ]; then
    s="${s:1}"
fi
if [ "su" = "$s" ]; then
    s="bash"
fi

test -f ${d}/.profile.${h} && . ${d}/.profile.${h}
test -f ${d}/.profile.${s} && . ${d}/.profile.${s}
test -f ${d}/.profile.${h}.${s} && . ${d}/.profile.${h}.${s}
true
