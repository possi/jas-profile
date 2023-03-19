# Windows 11 Tweaks

### Taskbar Gruppierung

`winget install Windhawk`


### Git / SSH

```powershell
[Environment]::SetEnvironmentVariable("GIT_SSH", "$((Get-Command ssh).Source)", [System.EnvironmentVariableTarget]::User)
```
https://snowdrift.tech/cli/ssh/git/tutorials/2019/01/31/using-ssh-agent-git-windows.html