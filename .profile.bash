test -f $HOME/.fzf.bash && . $HOME/.fzf.bash

if test "$UID" = 0 ; then
    PS1='\[\033[01;31m\]\h:\[\033[01;34m\]\w # \[\033[00m\]'
else
    PS1='\[\033[01;32m\]\u\[\033[01;31m\]@\h:\[\033[01;34m\]\w # \[\033[00m\]'
fi

d="$HOME/.config/jas-profile"
#shopt -s expand_aliases

. ${d}/.bash_aliases
