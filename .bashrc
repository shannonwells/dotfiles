cat ~/.bash_profile 
export EDITOR=vim
export PS1="\[\033[34m\]\h:\W \[\033[35m\]\$(parse_git_branch)\[\033[00m\]\$(git config user.initials)$\[\033[00m\] "
export SUDO_PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[0m\]'

export HISTCONTROL=ignoredups;
shopt -s histappend;
export PROMPT_COMMAND='echo -ne "\033]0;${USER}: ${PWD}\007"'

### FUNCTIONS

# This function is used in several aliases below.
function parse_git_branch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'; }

export -f parse_git_branch
for file in "$HOME/.bash_includes/*" ; do source $file ; done

eval "$(ssh-agent -s)"
