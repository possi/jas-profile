local ret_status="%(?::%{$fg_bold[red]%}[%?] )"
PROMPT='%(!..%{$fg_bold[green]%}%n%{$fg_bold[red]%}@)%{$fg_bold[red]%}%m %{$fg_bold[blue]%}%~ ${ret_status}%_$(prompt_char)%{$reset_color%} '
