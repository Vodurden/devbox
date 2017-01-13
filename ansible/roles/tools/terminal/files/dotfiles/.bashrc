#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# Git aliases
alias gc="git commit"
alias gf="git fetch --all"
alias gs="git status"
