jas-profile
===========

My Shell und vim Profiles with automatic installation

Setup
-----

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

Recommended cygwin enhancements (deprecated)
-------------------------------
* [apt-cyg](https://github.com/transcode-open/apt-cyg)
* [OH MY CYGWIN](https://github.com/haithembelhaj/oh-my-cygwin)
* chere-Package with icon added:
  ```reg
  Windows Registry Editor Version 5.00
  
  [HKEY_CLASSES_ROOT\Directory\Background]
  
  [HKEY_CLASSES_ROOT\Directory\Background\shell]
  
  [HKEY_CLASSES_ROOT\Directory\Background\shell\cygwin64_zsh]
  "Icon"="D:\\cygwin\\Cygwin-Terminal.ico"
  
  [HKEY_CLASSES_ROOT\Directory\shell]
  
  [HKEY_CLASSES_ROOT\Directory\shell\cygwin64_zsh]
  "Icon"="D:\\cygwin\\Cygwin-Terminal.ico"
  ```


### Replaced by
[Mintty for WSL](https://github.com/mintty/wsltty)

My Defaults
-----------
* Cygwin-Font: Consola with PowerLine ([consola.ttf](https://github.com/nicolalamacchia/powerline-consolas))
* Ubuntu-Font: [DejaVu Sans Mono for Powerline](https://github.com/powerline/fonts)
* Terminal-Size: 144 x 48

Internals:
----------

Update all dependencies:
```bash
git submodule -q foreach git pull origin master
```

WSL Workarounds
---------------
* SSH-Agent on Ubuntu 18.04: https://github.com/Microsoft/WSL/issues/3183#issuecomment-411138426
* Disable LC_ALL-Warning on SSH: Modify /etc/ssh/ssh_config and remove `SendEnv LANG LC_*`

References:
-----------

* [leyrer](https://github.com/leyrer/linux-home) - advanced tmux config ([thx EH18](https://www.youtube.com/watch?v=uxpUeieWHD8))  
  *I'm not only person to use bash profiles in a git repo*
