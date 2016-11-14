#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Correct colours for `ls`
alias ls='ls --color=auto'
eval `dircolors ~/.dircolors`

PS1='[\u@\h \W]\$ '
