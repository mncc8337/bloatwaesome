export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gianu" # murilasso dst duellj gianu

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"

# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

zstyle ':omz:update' frequency 15

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="false"

# DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="mm/dd/yyyy"

ENABLE_CORRECTION=true

# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(fzf z zsh-autosuggestions git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

eval $(thefuck --alias)

alias py="python3"
alias mv="mv -v"
alias cp="cp -v"
alias rm="rm -v"

export PATH="$HOME/.bin:$HOME/.local/bin:"$PATH
export VISUAL=nvim
export EDITOR="$VISUAL"

# set terminal colorscheme
function gogh() {
    source ~/PLAYGROUND/py-env/bin/activate
    bash -c "$(curl -sLo- https://git.io/vQgMr)"
    deactivate
}

# for some reason in my box XDG base directory env vars are not set
export XDG_CONFIG_HOME="$HOME/.config"
#export XDG_CACHE_HOME="$HOME/.cache"
#export XDG_DATA_HOME="$HOME/.local/share"
#export XDG_STATE_HOME="$HOME/.local/state"

# proxy stuff
# stolen from https://wiki.archlinux.org/title/Proxy_server
function proxy-on() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

    if (( $# > 0 )); then
        valid=$(echo $@ | sed -n 's/\([0-9]\{1,3\}.\?\)\{4\}:\([0-9]\+\)/&/p')
        if [[ $valid != $@ ]]; then
            >&2 echo "Invalid address"
            return 1
        fi
        local proxy=$1
        export http_proxy="$proxy" \
               https_proxy=$proxy \
               ftp_proxy=$proxy \
               rsync_proxy=$proxy
        echo "Proxy environment variable set."
        return 0
    fi

    echo -n "username: "; read username
    if [[ $username != "" ]]; then
        echo -n "password: "
        read -es password
        local pre="$username:$password@"
    fi

    echo -n "server: "; read server
    echo -n "port: "; read port
    local proxy=$pre$server:$port
    export http_proxy="$proxy" \
           https_proxy=$proxy \
           ftp_proxy=$proxy \
           rsync_proxy=$proxy \
           HTTP_PROXY=$proxy \
           HTTPS_PROXY=$proxy \
           FTP_PROXY=$proxy \
           RSYNC_PROXY=$proxy
    echo "Proxy environment variable set."
}

function proxy-off(){
    unset http_proxy https_proxy ftp_proxy rsync_proxy \
          HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY
    echo -e "Proxy environment variable removed."
}

crunchbang-mini
