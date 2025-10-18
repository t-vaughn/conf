# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$PATH:/home/ashley/.local/bin"

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
