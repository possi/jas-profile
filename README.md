jas-profile
===========

My Shell und vim Profiles with automatic installation

Setup
-----

Optional recommended software before setup:
```bash
apt install vim zsh screen
```

```bash
mkdir -p ~/.config;
git clone git@github.com:possi/jas-profile.git ~/.config/jas-profile;
bash ~/.config/jas-profile/setup.sh install-cloned;
```

**Quick-Setup:**
```bash
curl -s https://raw.githubusercontent.com/possi/jas-profile/master/setup.sh | bash; # or
wget -O - https://raw.githubusercontent.com/possi/jas-profile/master/setup.sh | bash; # or
lnyx -source https://raw.githubusercontent.com/possi/jas-profile/master/setup.sh | bash;
```

Optional configurations:
```bash
chsh -s /usr/bin/zsh
```

[Mintty for WSL](https://github.com/mintty/wsltty)
-------------------------------

### My Defaults
* Cygwin-Font: Consola with PowerLine ([consola.ttf](https://github.com/nicolalamacchia/powerline-consolas))
  * Alternativ alle Powerline-Fonts:  
    git clone https://github.com/powerline/fonts.git
    (Admin) powershell.exe -ExecutionPolicy Bypass .\install.ps1
  * https://github.com/Znuff/consolas-powerline
* Ubuntu-Font: [DejaVu Sans Mono for Powerline](https://github.com/powerline/fonts)
* Terminal-Size: 144 x 48
* Background... `24,24,24`

`%APPDATA%\wsltty\config`
```
BoldAsFont=no
Font=Consolas NF
Columns=144
Rows=48
Term=xterm-256color
CursorType=block
ThemeFile=jas-profile
# File jas-profile.minttyrc should be copied to %APPDATA%\wsltty\themes
BackgroundColour=24,24,24
```

Internals:
----------

Update all dependencies:
```bash
git submodule -q foreach git pull origin master
```

WSL Workarounds
---------------
* Use `c` for Windows Home-Directory: cmd: `setx WSLENV USERPROFILE/up`
* Disable LC_ALL-Warning on SSH: Modify /etc/ssh/ssh_config and remove `SendEnv LANG LC_*`
* Mount /mnt/c, etc with metadata but not with case sensitive  
  `/etc/wsl.conf`
    ```ini
    # https://blogs.msdn.microsoft.com/commandline/2018/02/07/automatically-configuring-wsl/
    #
    [automount]
    enabled = true
    # root = /mnt/
    options = "metadata"
    case = off
    # mountFsTab = true
    ```
  Source: https://devblogs.microsoft.com/commandline/per-directory-case-sensitivity-and-wsl/  
  Reason: https://github.com/yarnpkg/yarn/issues/5813

References:
-----------

* [leyrer](https://github.com/leyrer/linux-home) - advanced tmux config ([thx EH18](https://www.youtube.com/watch?v=uxpUeieWHD8))  
  *I'm not only person to use bash profiles in a git repo*
