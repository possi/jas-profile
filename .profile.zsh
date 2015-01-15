function prompt_char {
    if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

local ret_status="%(?::%{$fg_bold[red]%}[%?] )"
PROMPT='%(!..%{$fg_bold[green]%}%n%{$fg_bold[cyan]%}@)%{$fg_bold[cyan]%}%m %{$fg_bold[blue]%}%~ ${ret_status}%_$(prompt_char)%{$reset_color%} '

#ZSH_THEME_GIT_PROMPT_PREFIX="("
#ZSH_THEME_GIT_PROMPT_SUFFIX=") "

zstyle ':completion:*' special-dirs true
zstyle ':completion:*' accept-exact-dirs true

##
## http://zshwiki.org/home/zle/bindkeys
##
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
#key[Insert]=${terminfo[kich1]}
#key[Delete]=${terminfo[kdch1]}
#key[Up]=${terminfo[kcuu1]}
#key[Down]=${terminfo[kcud1]}
#key[Left]=${terminfo[kcub1]}
#key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
#[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
#[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
#[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
#[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
#[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
#[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" history-beginning-search-forward
bindkey "^[[5~" history-beginning-search-backward # PageUp
bindkey "^[[6~" history-beginning-search-foward   # PageDown
bindkey "[1;3D" backward-word  # Alt-Left
bindkey "[1;3C" forward-word   # Alt-Right

# putty, dev.point-rouge.de
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[D" backward-word # ctrl?
bindkey "^[[C" forward-word
bindkey "^[^[OD" backward-word # test?
bindkey "^[^[OC" forward-word

if [[ -n ${terminfo[smkx]} ]] && [[ -n ${terminfo[rmkx]} ]]; then
    # Finally, make sure the terminal is in application mode, when zle is
    # active. Only then are the values from $terminfo valid.
    function zle-line-init () {
        echoti smkx
    }
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish  
fi
