#!/bin/bash
_TARGET_PATH=".config/jas-profile"
TARGET_DIR="${HOME}/${_TARGET_PATH}"
TMP_PATH="${TARGET_DIR}/.tmp"
TOOLS_PATH="${TARGET_DIR}/.tmp"
BIN_PATH="${TARGET_DIR}/.bin"
LINK_TARGET_DIR="${_TARGET_PATH}"
REPOSITORY="https://github.com/possi/jas-profile.git"
PROFILE_SRC="# jas-profile
test -f \${HOME}/${LINK_TARGET_DIR}/.profile && . \${HOME}/${LINK_TARGET_DIR}/.profile
# end jas-profile"
XPROFILE_SRC="# jas-profile
test -f \${HOME}/${LINK_TARGET_DIR}/.xprofile && . \${HOME}/${LINK_TARGET_DIR}/.xprofile
# end jas-profile"

download () {
    SOURCE_REP="https://raw.githubusercontent.com/possi/jas-profile/master/"

    echo "Downloading file: ${1}"
    local tfile=$1
    if [ "$2" != "" ]; then
        tfile=$2
    fi
    if [ "$(which curl 2>/dev/null)" != "" ]; then
        curl -s -S -k ${SOURCE_REP}${1} > ${tfile}
    elif [ "$(which wget 2>/dev/null)" != "" ]; then
        wget -q --no-check-certificate -O ${tfile} ${SOURCE_REP}${1}
    elif [ "$(which lynx 2>/dev/null)" != "" ]; then
        lynx -source ${SOURCE_REP}${1} > ${tfile} 
    else
        echo "No curl or wget or lynx to download files found."
        exit 1
    fi
}

# download .inputrc .tmp_inputrc
# if [ ! -f .inputrc ] || grep -v -q "#jas" .inputrc; then
#     if [ -f /etc/inputrc ]; then
#         cp /etc/inputrc .inputrc
#         echo "" >> .inputrc
#     fi
#     cat .tmp_inputrc >> .inputrc
# fi
# rm .tmp_inputrc
# download .screenrc
# download .vimrc
# download .profile .jas_profile
# if [ ! -f .profile ] || grep -v -q .jas_profile .profile; then
#     echo "" >> .profile
#     echo "#jas" >> .profile
#     echo "test -f ~/.jas_profile && . ~/.jas_profile" >> .profile
# fi


#### Dependencies

# fzf

install_fzf() {
    if [ -e $TOOLS_PATH/fzf ]; then
        pushd $TOOLS_PATH/fzf >/dev/null
        git pull
        popd >/dev/null
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git $TOOLS_PATH/fzf
    fi
    $TOOLS_PATH/fzf/install --all --key-bindings --completion --no-update-rc
}

install_exa() {
    RELEASE=https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
    ZIP=$(basename $RELEASE)
    pushd $TMP_PATH >/dev/null
    mkdir -p $TOOLS_PATH/exa
    wget $RELEASE
    unzip $ZIP -d $TOOLS_PATH/exa
    ln -s $TOOLS_PATH/exa/bin/exa $BIN_PATH/
    rm $ZIP
    popd >/dev/null
}


function hr {
  sed '
  1d
  $d
  s/  //
  ' <<< "$1"
}

function usage {
    hr '
    Usage: setup.sh [command]

    Commands:
        install-cloned      Installs the already cloned profile
        update              Ensures that everything ist up-to-date
        zsh [bashrc]        Enables ZSH as default shell (Optional using bashrc, if user has no password)
        extras-install      Installs Extra Binaries: exa
    '
}

bcd="${TARGET_DIR}/.bck/$(date +%y%m%d%H%M%S)"
function setup_zsh {
    if [ "$(which zsh &2>/dev/null)" = "" ]; then
        echo "ZSH isn't installed."
        exit 1
    fi
    if [ "$1" != "bashrc" ]; then
        echo "> chsh -s $(which zsh)"
        chsh -s $(which zsh)
    else
        CONTENT='
# jas-profile launch ZSH
if [ ! -z "$PS1" ]; then
  zsh --login
  exit
fi
'

        if [ ! -e "${HOME}/.bashrc" ]; then
            echo "# Creating .bashrc"
            echo "$CONTENT" > $HOME/.bashrc
        elif ! grep -q "# jas-profile" "${HOME}/.bashrc"; then
            echo "# Prepending .basrc"
            mkdir -p "${bcd}"
            cp "$HOME/.bashrc" "${bcd}/.bashrc"
            echo "$CONTENT" | cat - $HOME/.bashrc > $HOME/.temp_bashrc && mv $HOME/.temp_bashrc $HOME/.bashrc
        else
            echo "# Skipping already patched .bashrc"
        fi
    fi
}
function install_file_link() {
    f="${HOME}/${1}"
    if [ "" != "${2}" ]; then
        lt="${LINK_TARGET_DIR}/${2}"
        t="${TARGET_DIR}/${2}"
    else
        lt="${LINK_TARGET_DIR}/${1}"
        t="${TARGET_DIR}/${1}"
    fi

    if [ -L "$f" ]; then
        # Alread is a symlink
        current_link="$(readlink "$f")"
        if [ "$current_link" != "$lt" ]; then
            echo "Removing current link:      $1 => $current_link"
            rm "$f"
        else
            echo "Link is already up to date: $1"
            return
        fi
    elif [ -e "$f" ]; then
        # Backup
        mkdir -p "${bcd}"
        echo "Backuping current file:     $1 => $bcd/$1"
        mv "$f" "${bcd}/${1}"
    fi
    echo "Creating link:              $1"
    [ ! -d $(dirname "$f") ] && mkdir -p $(dirname "$f")
    ln -s "$lt" "$f"
}

# Helper
function update_symlinks {
    if [ "$(which vim 2>/dev/null)" != "" ]; then
        install_file_link .vim
        install_file_link .vimrc
    elif [ "$(which vi 2>/dev/null)" != "" ]; then
        install_file_link .vimrc .vimrc-lite
    fi
    if [ "$(which screen 2>/dev/null)" != "" ]; then
        install_file_link .screenrc
    fi
    if [ "$(which tmux 2>/dev/null)" != "" ]; then
        install_file_link .tmux.conf
    fi
    # install_file_link .bashrc
    install_file_link .inputrc $(merge_inputrc)
    if [ "$(which zsh 2>/dev/null)" != "" ]; then
        install_file_link .zshrc
    fi
}
function copy_defaults {
    if [ -d "$USERPROFILE/AppData/Roaming/wsltty/themes" ]; then
        cp $TARGET_DIR/jas-profile.minttyrc "$USERPROFILE/AppData/Roaming/wsltty/themes/jas-profile"
    fi
}
function git_submodule_install {
    pushd "${TARGET_DIR}" >/dev/null
    git submodule update -f --init --recursive
    popd >/dev/null
}
function fix_permissions {
    pushd "${TARGET_DIR}" >/dev/null
    chmod -R go-w .oh-my-zsh
    popd >/dev/null
}
function update_vim {
    echo -n "Updating vim-plugins... "
    vim +PluginInstall +qall 2>/dev/null
    echo "done"
}
function modify_profile {
    if [ ! -e "${HOME}/.profile" ]; then
        echo "Creating ~/.profile"
        echo -e "$PROFILE_SRC" > "${HOME}/.profile"
    elif ! grep -q "# jas-profile" "${HOME}/.profile"; then
        echo "Appending to ~/.profile"
        echo -e "\n$PROFILE_SRC" >> "${HOME}/.profile"
    else
        echo "Updating ~/.profile"
        nsrc="$(echo -e "$PROFILE_SRC" | sed ':a;N;$!ba;s/\n/\\n/g')"
        sed -i '/^# jas-profile/,/^# end jas-profile/ c \'"$nsrc" "${HOME}/.profile"
    fi
}
function modify_xprofile {
    if [ ! -e "${HOME}/.xprofile" ]; then
        echo "Creating ~/.xprofile"
        echo -e "$XPROFILE_SRC" > "${HOME}/.xprofile"
    elif ! grep -q "# jas-profile" "${HOME}/.xprofile"; then
        echo "Appending to ~/.xprofile"
        echo -e "\n$XPROFILE_SRC" >> "${HOME}/.xprofile"
    else
        echo "Updating ~/.xprofile"
        nsrc="$(echo -e "$XPROFILE_SRC" | sed ':a;N;$!ba;s/\n/\\n/g')"
        sed -i '/^# jas-profile/,/^# end jas-profile/ c \'"$nsrc" "${HOME}/.xprofile"
    fi
}
function merge_inputrc() {
    if [ -e /etc/inputrc ]; then
        cat /etc/inputrc > "${TARGET_DIR}/.inputrc.merged"
        echo "" >> "${TARGET_DIR}/.inputrc.merged"
        cat "${TARGET_DIR}/.inputrc" >> "${TARGET_DIR}/.inputrc.merged"
        echo ".inputrc.merged"
    else
        echo ".inputrc"
    fi
}
function include_gitconfig() {
    if git config --global --get-all include.path | grep .config/jas-profile/.gitconfig >/dev/null; then
        echo ".gitconfig already included"
    else
        git config --global --add include.path .config/jas-profile/.gitconfig
        echo "incuding .gitconfig"
    fi
}
function install_dependencies() {
    install_fzf
}


execute_install() {
    git_submodule_install
    fix_permissions
    update_symlinks
    copy_defaults
    modify_profile
    if [ "$(which startx 2>/dev/null)" != "" ]; then
        modify_xprofile
    fi
    include_gitconfig
    if [ "$(which vim 2>/dev/null)" != "" ]; then
        update_vim
    fi
    install_dependencies
}

# Main-Commands
function install {
    execute_install
}
function update {
    pushd "${TARGET_DIR}" >/dev/null
    git pull
    popd >/dev/null

    execute_install
}
function extras {
    install_exa
}

if [ ! -d "${HOME}" ]; then
    echo "Serious error: Home-Directory (${HOME}) not found."
    exit 1
fi

case "$1" in
    install-cloned)
        install
    ;;
    update)
        update
    ;;
    zsh)
        setup_zsh $2
    ;;
    extras-install)
        extras
    ;;
    *)
        if [ "bash" = "$0" ]; then
            # Quick-Setup
            if [ "$(which git 2>/dev/null)" = "" ]; then
                echo "Quick-Setup failed, git client ist not installed"
                exit 1
            fi
            if [ -e "${TARGET_DIR}/setup.sh" ]; then
                echo "jas-profile seems to be already installed. Try:"
                echo "${TARGET_DIR}/setup.sh install-cloned"
            fi

            mkdir -p $(dirname "${TARGET_DIR}")
            git clone "${REPOSITORY}" "${TARGET_DIR}"
            chmod u+x "${TARGET_DIR}/setup.sh"
            bash "${TARGET_DIR}/setup.sh" install-cloned
        else
            usage
        fi
    ;;
esac

