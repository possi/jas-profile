local ret_status="%(?::%{$fg_bold[red]%}[%?] )"
PROMPT='%(!..%{$fg_bold[green]%}%n) %{$fg_bold[blue]%}%~ ${ret_status}%_$(prompt_char)%{$reset_color%} '
