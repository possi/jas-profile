function prompt_char {
    if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

local ret_status="%(?::%{$fg_bold[red]%}[%?] )"
PROMPT='%(!..%{$fg_bold[green]%}%n%{$fg_bold[cyan]%}@)%{$fg_bold[cyan]%}%m %{$fg_bold[blue]%}%~ ${ret_status}%_$(prompt_char)%{$reset_color%} '

#ZSH_THEME_GIT_PROMPT_PREFIX="("
#ZSH_THEME_GIT_PROMPT_SUFFIX=") "
