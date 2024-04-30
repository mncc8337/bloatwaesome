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

# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(fzf zsh-interactive-cd)

source $ZSH/oh-my-zsh.sh

# User configuration

alias py="python3"
alias mv="mv -v"
alias cp="cp -v"
alias rm="rm -v"

export PATH="$HOME/.bin:"$PATH
export VISUAL=nvim
export EDITOR="$VISUAL"

# set terminal colorscheme
gogh() {
    source ~/PLAYGROUND/py-env/bin/activate
    bash -c "$(curl -sLo- https://git.io/vQgMr)"
    deactivate
}

# for some reason in my box XDG base directory env vars are not set
export XDG_CONFIG_HOME="$HOME/.config"
#export XDG_CACHE_HOME="$HOME/.cache"
#export XDG_DATA_HOME="$HOME/.local/share"
#export XDG_STATE_HOME="$HOME/.local/state"

crunchbang-mini
