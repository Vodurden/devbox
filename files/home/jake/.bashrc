#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Correct colours for `ls`
alias ls='ls --color=auto'
eval `dircolors ~/.dircolors`

# Add ruby binaries to the PATH
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

PS1='[\u@\h \W]\$ '
