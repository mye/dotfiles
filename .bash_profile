#~/scripts/keychain ~/.ssh/id_rsa ~/.ssh/id_dsa
#source ~/.keychain/snow-sh > /dev/null

if [ -e "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

### variables
export PATH="$HOME/scripts:/usr/local/bin:/usr/bin:/bin"
export LANG="en_US.UTF-8"
export HOSTFILE=$HOME/.hosts
export EDITOR=vim
# LD_LIBRARY_PATH, LD_RUN_PATH, CLASSPATH, PYTHONPATH, PKG_CONFIG_PATH
# BASH default for histfile is ~/.bash_history
export HISTSIZE=1010
export HISTFILESIZE=1010
export HISTIGNORE="mutt:[bf]g:exit:&:[ ]*"
export HISTCONTROL=erasedups
export CVSROOT=/home/mye/cvsroot

for i in $HOME/local/*; do
  [ -d $i/bin ] && PATH="${i}/bin:${PATH}"
  [ -d $i/include ] && CPATH="${i}/include:${CPATH}"
  [ -d $i/lib ] && LD_LIBRARY_PATH="${i}/lib:${LD_LIBRARY_PATH}"
  [ -d $i/lib/pkgconfig ] && PKG_CONFIG_PATH="${i}/lib/pkgconfig:${PKG_CONFIG_PATH}"
  [ -d $i/share/man ] && MANPATH="${i}/share/man:${MANPATH}"
done

#### prompt
#PROMPT_COMMAND='history -a;settitle "$PWD"'
NON="\[\e[0m\]"
RED="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
GRE="\[\033[0;32m\]" # green
YEL="\[\033[0;33m\]"
BLU="\[\033[0;34m\]"
VIO="\[\033[0;35m\]"
CYA="\[\033[0;36m\]"
GRA="\[\033[0;37m\]" # gray
WHI="\[\033[1;37m\]"
LED="\[\033[1;31m\]" # light red
LIO="\[\033[1;35m\]"
LRE="\[\033[1;32m\]"
export PS1="$LED\n\h$GRE:$GRA\w$YEL\$(__git_ps1)$GRA\n\$SHLVL# $NON"

# Set MANPATH so it includes users' private man if it exists
# if [ -d "${HOME}/man" ]; then
#   MANPATH=${HOME}/man:${MANPATH}
# fi
# Set INFOPATH so it includes users' private info if it exists
# if [ -d "${HOME}/info" ]; then
#   INFOPATH=${HOME}/info:${INFOPATH}
# fi

## vim:fdm=expr:fdl=0
## vim:fde=getline(v\:lnum)=~'^##'?'>'.(matchend(getline(v\:lnum),'##*')-2)\:'='
