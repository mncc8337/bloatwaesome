#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias py="python3"
alias fuck="thefuck"

ITAN="\[$(tput sitm)\]"
ITAF="\[$(tput ritm)\]"
BOLD="\[$(tput bold)\]"
DGRE="\[$(tput setaf 8)\]"
GREY="\[$(tput setaf 15)\]"
REDD="\[$(tput setaf 1)\]"
BLUE="\[$(tput setaf 4)\]"
CYAN="\[$(tput setaf 6)\]"
CLER="\[$(tput sgr0)\]"
#PS0="${CLER}"
PS1_temp="${BLUE} ${DGRE}${ITAN}\u@\h${ITAF}\n${GREY}[${CYAN}${BOLD}\w${CLER}${GREY}]${BLUE}${BOLD}>${CLER} "

function title() {
    title="$1"
    if [[ "$title" = "-r" ]] || [[ "$title" = "--reset" ]]
    then
        PS1=$PS1_temp
    else
        PS1="\[\e]2;$title\a\]"$PS1_temp
    fi
}

PS1=$PS1_temp
