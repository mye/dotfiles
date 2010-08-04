### Shell options
set -o ignoreeof
shopt -s histappend histreedit histverify cmdhist
shopt -s checkwinsize
shopt -s no_empty_cmd_completion
shopt -u mailwarn
unset MAILCHECK
stty -ixon -ixoff # Turn flow control off

### Aliases
alias less='less -r' # raw control characters
alias grep='grep --color' # show differences in colour
alias screen='TERM=xterm-256color screen -T screen-256color'

alias ff='find . -iname'
alias cl=clear
alias so='source ~/.bashrc'
alias cpdir='cp -Rpv'
alias ls='ls -p --file-type --color=always --group-directories-first --human-readable'
alias ll='ls -opX --size'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ..;cd ..'

alias more='less'
export PAGER=less
#alias systail='tail -f /var/log/
# git
alias gco='git checkout'
alias gst='git status'
# make auto completion work with alias
complete -o default -o nospace -F _git_checkout gco
complete -o default -o nospace -F _git_branch gb

### Functions
function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }
function ff() { find . -type f -iname '*'$*'*' -ls ; }
function mkcd() { mkdir "$@" && cd "$@"; }

function cs() {
  clear
  [ -n "$1" ] && cd "$1"
  ls
}

function cmdstash() {
  getopts ":l" opt;
  if [ "$opt" == "l" ]
  then
    echo "$(fc -ln -1)" | sed -e 's/^[ \t]*//g' >> .cmdstash
  else
    echo "$(fc -ln -1)" | sed -e 's/^[ \t]*//g' >> "$HOME/.cmdstash"
  fi
  echo "Added: $(fc -ln -1)"
}

hf(){
  grep "$@" ~/.bash_history
}

#### Handy Extract Program.
function extract()      
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xvjf $1     ;;
      *.tar.gz)    tar xvzf $1     ;;
      *.bz2)       bunzip2 $1      ;;
      *.rar)       unrar x $1      ;;
      *.gz)        gunzip $1       ;;
      *.tar)       tar xvf $1      ;;
      *.tbz2)      tar xvjf $1     ;;
      *.tgz)       tar xvzf $1     ;;
      *.zip)       unzip $1        ;;
      *.Z)         uncompress $1   ;;
      *.7z)        7z x $1         ;;
      *)           echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

## end functions

### completion
COMP_CONFIGURE_HINTS=1
COMP_TAR_INTERNAL_PATHS=1
if [ -e /etc/bash_completion ] ; then
  source /etc/bash_completion > /dev/null
fi

GIT_EDITOR=vim
GIT_PS1_SHOWDIRTYSTATE=1
source ~/scripts/git-completion.bash

## vim:fdm=expr:fdl=0
## vim:fde=getline(v\:lnum)=~'^##'?'>'.(matchend(getline(v\:lnum),'##*')-2)\:'='
