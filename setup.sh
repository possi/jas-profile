#!/bin/bash
# -- https://gist.github.com/possi/6155726 --
# Install via:
#  curl -s https://gist.githubusercontent.com/possi/6155726/raw/setup.sh | bash
# or:
#  wget -O - https://gist.githubusercontent.com/possi/6155726/raw/setup.sh | bash

echo "Starting jas Bash Env configuration..."

cd; # switch to home dir

download () {
    echo "Downloading file: ${1}"
    local tfile=$1
    if [ "$2" != "" ]; then
        tfile=$2
    fi
    if [ "$(which curl)" != "" ]; then
        curl -s -S -k https://gist.githubusercontent.com/possi/6155726/raw/${1} > ${tfile}
    elif [ "$(which wget)" != "" ]; then
        wget -q --no-check-certificate -O ${tfile} https://gist.githubusercontent.com/possi/6155726/raw/${1}
    else
        echo "No curl or wget to download files found."
        exit 1
    fi
}

download .inputrc .tmp_inputrc
if [ ! -f .inputrc ] || grep -v -q "#jas" .inputrc; then
    if [ -f /etc/inputrc ]; then
        cp /etc/inputrc .inputrc
        echo "" >> .inputrc
    fi
    cat .tmp_inputrc >> .inputrc
fi
rm .tmp_inputrc
download .screenrc
download .vimrc
download .profile .jas_profile
if [ ! -f .profile ] || grep -v -q .jas_profile .profile; then
    echo "" >> .profile
    echo "#jas" >> .profile
    echo "test -f ~/.jas_profile && . ~/.jas_profile" >> .profile
fi
