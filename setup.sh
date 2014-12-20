#!/bin/bash
_TARGET_PATH=".config/jas-profile"
TARGET_DIR="${HOME}/${_TARGET_PATH}"
LINK_TARGET_DIR="${_TARGET_PATH}"
REPOSITORY="git@github.com:possi/jas-profile.git"
PROFILE_SRC="# jas-profile
test -f ${LINK_TARGET_DIR}/.profile && . ${LINK_TARGET_DIR}/.profile
# end jas-profile"

download () {
    SOURCE_REP="https://raw.githubusercontent.com/possi/jas-profile/master/"

    echo "Downloading file: ${1}"
    local tfile=$1
    if [ "$2" != "" ]; then
        tfile=$2
    fi
    if [ "$(which curl)" != "" ]; then
        curl -s -S -k ${SOURCE_REP}${1} > ${tfile}
    elif [ "$(which wget)" != "" ]; then
        wget -q --no-check-certificate -O ${tfile} ${SOURCE_REP}${1}
    elif [ "$(which lynx)" != "" ]; then
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
    '
}

bcd="${TARGET_DIR}/.bck/$(date +%y%m%d%H%M%S)"
function install_file_link() {
    f="${HOME}/${1}"
    if [ "" != "${2}" ]; then
        lt="${LINK_TARGET_DIR}/${2}"
        t="$(realpath "${TARGET_DIR}/${2}")"
    else
        lt="${LINK_TARGET_DIR}/${1}"
        t="$(realpath "${TARGET_DIR}/${1}")"
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
    install_file_link .vim
    install_file_link .vimrc
    install_file_link .screenrc
    install_file_link .inputrc $(merge_inputrc)
}
function git_submodule_install {
    pushd "${TARGET_DIR}" >/dev/null
    git submodule update -f --init --recursive
    popd >/dev/null
}
function update_vim {
    echo -n "Updating vim-plugins... "
    vim +PluginInstall +qall
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


# Main-Commands
function install {
    git_submodule_install
    update_vim
    update_symlinks
    modify_profile
}
function update {
    pushd "${TARGET_DIR}" >/dev/null
    git pull
    popd >/dev/null
    git_submodule_install
    update_vim
    update_symlinks
    modify_profile
}

if [ ! -d "${HOME}" ]; then
    echo "Serious error: Home-Direcotry (${HOME}) not found."
    exit 1
fi

case "$1" in
    install-cloned)
        install
    ;;
    update)
        update
    ;;
    #test)
    #    modify_profile
    #;;
    *)
        if [ "bash" = "$0" ]; then
            # Quick-Setup
            if [ "$(which git)" = "" ]; then
                echo "Quick-Setup failed, git client ist not installed"
                exit 1
            fi
            if [ -e "${TARGET_DIR}/setup.sh" ]; then
                echo "jas-profile seems to be already installed. Try:"
                echo "${TARGET_DIR}/setup.sh install-cloned"
            fi

            mkdir -P $(dirname "${TARGET_DIR}")
            git clone "${REPOSITORY}" "${TARGET_DIR}"
            bash "${TARGET_DIR}/setup.sh" install-cloned
        else
            usage
        fi
    ;;
esac

