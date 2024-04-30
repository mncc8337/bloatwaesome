#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias py="python3"

export ITAN="\[$(tput sitm)\]"
export ITAF="\[$(tput ritm)\]"
export BOLD="\[$(tput bold)\]"
export DGRE="\[$(tput setaf 8)\]"
export GREY="\[$(tput setaf 15)\]"
export REDD="\[$(tput setaf 1)\]"
export BLUE="\[$(tput setaf 4)\]"
export CYAN="\[$(tput setaf 6)\]"
export CLER="\[$(tput sgr0)\]"
#PS0="${CLER}"
$HOME/bin/panes
PS1="${BLUE} ${DGRE}${ITAN}\u@\h${ITAF} ${GREY}[${CYAN}${BOLD}\w${CLER}${GREY}]\n${BLUE}${BOLD}>${CLER} "
