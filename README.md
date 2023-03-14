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
~/.config/jas-profile/setup.sh zsh
~/.config/jas-profile/setup.sh extras-install
```

[Mintty for WSL](https://github.com/mintty/wsltty)
-------------------------------

### My Defaults
* Consolas NF:  
  ```PowerShell
  md in
  md out
  copy $Env:WINDIR/Fonts/consola*.ttf in/
  docker run --rm -v ${PWD}/in:/in -v ${PWD}/out:/out nerdfonts/patcher -c
  ```
  (**Important:** Use Right-Click [UAC] Install for all Users)
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

`%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
```json
{
    "actions": 
    [
        {
            "command": "scrollDownPage",
            "keys": "shift+pgdn"
        },
        {
            "command": "unbound",
            "keys": "ctrl+shift+pgup"
        },
        {
            "command": "unbound",
            "keys": "ctrl+shift+pgdn"
        },
        {
            "command": "scrollUpPage",
            "keys": "shift+pgup"
        },
        // ...
    ],
    // ...
    "initialCols": 160,
    "initialRows": 48,
    "profiles": 
    {
        "defaults": 
        {
            "bellStyle": 
            [
                "audible",
                "taskbar"
            ],
            "closeOnExit": "always",
            "font": 
            {
                "face": "Consolas Nerd Font",
                "size": 10.0
            }
        },
        // ...
    },
    "schemes":
    [
        // ...
        {
            "background": "#181818",
            "black": "#0C0C0C",
            "blue": "#217DBB",
            "brightBlack": "#404040",
            "brightBlue": "#3498DB",
            "brightCyan": "#40FFFF",
            "brightGreen": "#2ECC71",
            "brightPurple": "#9B59B6",
            "brightRed": "#E74C3C",
            "brightWhite": "#DFDFDF",
            "brightYellow": "#F1C40F",
            "cursorColor": "#BFBFBF",
            "cyan": "#14888F",
            "foreground": "#FFFFFF",
            "green": "#25A25A",
            "name": "Exa Mintty",
            "purple": "#804399",
            "red": "#D62C1A",
            "selectionBackground": "#BABABA",
            "white": "#CCCCCC",
            "yellow": "#C29D0B"
        }
    ]
}
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
