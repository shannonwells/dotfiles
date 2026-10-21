export EDITOR=vim

export PROMPT_COMMAND='echo -ne "\033]0;${USER}: ${PWD}\007"'

export HISTCONTROL=ignoredups;
setopt histappend;

source ./.aliases

# This function is used in several aliases below.
function parse_git_branch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'; }

export -f parse_git_branch

# bash version
#export PS1="\[\033[34m\]\h:\W \[\033[35m\]\$(parse_git_branch)\[\033[00m\]\$(git config user.initials)$\[\033[00m\] "
PROMPT_BASE='%{\e[34m%}%m:%{\e[0;36m%}%1~ %{\e[35m%}$(parse_git_branch)%{\e[00m%}$(git config user.initials)%# %{\e[00m%} #'


eval "$(ssh-agent -s)"

