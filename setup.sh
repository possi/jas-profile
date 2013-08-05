#!/bin/bash
# -- https://gist.github.com/possi/6155726 --
# Install via:
#  curl -s https://gist.github.com/possi/6155726/raw/setup.sh | bash
# or:
#  wget -O - https://gist.github.com/possi/6155726/raw/setup.sh | bash

echo "Starting jas Bash Env configuration..."

cd; # switch to home dir

download () {
    echo "Downloading file: $1"
    local tfile = $1
    if [ $2 != "" ]; then
        tfile = $2
    end
    if [ "$(which curl)" != "" ]; then
        wget -q --no-check-certificate -O {$tfile} https://gist.github.com/possi/6155726/raw/{$1}
    elif [ "$(which wget)" != "" ]; then
        curl -s https://gist.github.com/possi/6155726/raw/{$1} > {$tfile}
    else
        echo "No curl or wget to download files found.
        exit 1
    fi
}

download .inputrc
download .screenrc
download .vimrc
download .profile