# Copied from sources around the internet including:
# http://github.com/godlygeek/zsh-files/blob/master/.zshrc
# http://git.grml.org/?p=grml-etc-core.git;a=blob_plain;f=etc/zsh/zshrc;hb=HEAD
~/scripts/keychain ~/.ssh/id_rsa ~/.ssh/id_dsa
source ~/.keychain/snow-sh > /dev/null
PATH="$HOME/scripts:/usr/local/bin:/usr/bin:/bin"
JAVA="$W/CommonFiles/Java/bin"
SYSIN="$W/SysinternalsSuite"
PATH="$PATH:$JAVA:$SYSIN"
### Cygwin/Windows integration
# This gets us the cygwin path to the directory above cygwins /
export PORTABLE="$(dirname -- "$(cygpath -m /)" | xargs -0 cygpath)"
export W="$PORTABLE/windows"
export WW="$(cygpath -wa "$W")"
export CYGWIN="nodosfilewarning tty notitle glob"
export MANPATH="$W/mingw/man:$MANPATH"
alias cdd='cd "$(cygpath -D)"'
alias cdp='cd "$PORTABLE"'
alias explorer='cyg-wrapper.sh "$WINDIR/explorer ." --slashed-opt'
alias ahk='cyg-wrapper.sh "$W/ahk/AutoHotkey" &'
gvim()
{
  unset VIM VIMRUNTIME MYVIMRC
  cyg-wrapper.sh "$W/vim/vim72self/gvim.exe" \
    --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr \
    --cyg-verbose --fork=1 "$@"
}

### SETUP
# These settings are only for interactive shells. Return if not interactive.
# This stops us from ever accidentally executing, rather than sourcing, .zshrc
[[ -o nointeractive ]] && return

# Disable flow control, since it really just annoys me.
stty -ixon &>/dev/null

# customize the colors used by ls, if we have the right tools
# Also changes colors for completion, if initialized first
which dircolors &>/dev/null && eval $(dircolors -b ~/.dircolors)

#### Optional Behaviors
# Setting any of these options will modify the behavior of a new shell to
# better suit your needs.  These values given specify the default for each
# option when the shell starts.  At the moment, changing shellopts[utf8] during
# an execution does nothing whatsoever, as it only sets up some aliases and
# variables when the shell starts.  However, all of the other options can be
# changed while the shell is running to change its behavior from that point
# forward.
typeset -A shellopts
shellopts[utf8]=1         # Set up a few programs for UTF-8 mode
shellopts[titlebar]=1     # Whether the titlebar can be dynamically changed
shellopts[screen_names]=1 # Dynamically change window names in GNU screen
shellopts[preexec]=1      # Run preexec to update screen title and titlebar
shellopts[precmd]=1       # Run precmd to show job count and retval in RPROMPT
shellopts[rprompt]=1      # Show the right-side time, retval, job count prompt.
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
bindkey -e # emacs line editing
#zstyle :compinstall filename '/home/mye/.zshrc'

### Aliases
# First off, allow commands after sudo to still be alias expanded.
# An alias ending in a space allows the next word on the command line to
# be alias expanded as well.
alias xetex='~/minixetex/xetex'
alias so='source ~/.zshrc'
alias sudo="sudo "
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -l'
alias ls='ls --color=auto -B'
alias grep='grep --color=auto'
alias pu='pushd'
alias po='popd'
alias ..='cd ..'
alias ...='cd ..;cd ..'
alias cd..='cd ..'
alias cd/='cd /'
alias vi='vim'

alias -g L='|less'
alias -g T='|tail'
alias -g H='|head'
alias -g V='|vim -'
alias -g B='&>/dev/null &'
alias -g D='&>/dev/null &|'

### Prompt
#typeset +x PS1     # Don't export PS1 - Other shells just mangle it.
if [ -z $DOPROMPT  ]
then
  PS1=$'%{\e[1;31m%}%#%{\e[0m%} '
  [[ $SHLVL -gt 1 ]] && PS1="$SHLVL$PS1"
fi
#RPS1=$(basename -- "%d")

### Environment variables
export SHELL=$(whence -p zsh)             # Let apps know the full path to zsh
export DIRSTACKSIZE=10                    # Max number of dirs on the dir stack
export LANG=en_US.UTF-8                   # Use a unicode english locale
export TMP=/tmp                           # Overwrite windows TMP and TEMP
export TEMP=$TMP

HISTFILE=~/.histfile
HISTSIZE=5500
SAVEHIST=5000

### Completion
autoload -Uz compinit
compinit

### Functions
#### Smart archive extractor
extract () {
  emulate -L zsh
  if [[ -f $1 ]] ; then
    case $1 in
      *.tar.bz2)  bzip2 -v -d $1      ;;
      *.tar.gz)   tar -xvzf $1        ;;
      *.rar)      unrar $1            ;;
      *.deb)      ar -x $1            ;;
      *.bz2)      bzip2 -d $1         ;;
      *.lzh)      lha x $1            ;;
      *.gz)       gunzip -d $1        ;;
      *.tar)      tar -xvf $1         ;;
      *.tgz)      gunzip -d $1        ;;
      *.tbz2)     tar -jxvf $1        ;;
      *.zip)      unzip $1            ;;
      *.Z)        uncompress $1       ;;
      *)          echo "'$1' Error. Please go away" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#### Usage: smartcompress <file> (<type>)
smartcompress() {
  emulate -L zsh
  if [[ -n $2 ]] ; then
    case $2 in
      tgz | tar.gz)   tar -zcvf$1.$2 $1 ;;
      tbz2 | tar.bz2) tar -jcvf$1.$2 $1 ;;
      tar.Z)          tar -Zcvf$1.$2 $1 ;;
      tar)            tar -cvf$1.$2  $1 ;;
      gz | gzip)      gzip           $1 ;;
      bz2 | bzip2)    bzip2          $1 ;;
      *)
      echo "Error: $2 is not a valid compression type"
      ;;
    esac
  else
    smartcompress $1 tar.gz
  fi
}

#### show-archive
show-archive() {
  emulate -L zsh
  if [[ -f $1 ]] ; then
    case $1 in
      *.tar.gz)      gunzip -c $1 | tar -tf - -- ;;
      *.tar)         tar -tf $1 ;;
      *.tgz)         tar -ztf $1 ;;
      *.zip)         unzip -l $1 ;;
      *.bz2)         bzless $1 ;;
      *.deb)         dpkg-deb --fsys-tarfile $1 | tar -tf - -- ;;
      *)             echo "'$1' Error. Please go away" ;;
    esac
  else
    echo "'$1' is not a valid archive"
  fi
}

#### Show some status info
status() {
  print
  print "Date..: "$(date "+%Y-%m-%d %H:%M:%S")
  print "Shell.: Zsh $ZSH_VERSION (PID = $$, $SHLVL nests)"
  print "Term..: $TTY ($TERM), ${BAUD:+$BAUD bauds, }$COLUMNS x $LINES chars"
  print "Login.: $LOGNAME (UID = $EUID) on $HOST"
  print "System: $(cat /etc/[A-Za-z]*[_-][rv]e[lr]*)"
  print "Uptime:$(uptime)"
  print
}

#### find by name
function ff() { find . -iname '*'$*'*' ; }

#### Auxiliary
function mkcd() { mkdir "$@" && cd "$@"; }

function cs() {
  clear
  [ -n "$1" ] && cd "$1"
  ls
}

## vim:fdm=expr:fdl=0
## vim:fde=getline(v\:lnum)=~'^##'?'>'.(matchend(getline(v\:lnum),'##*')-2)\:'='
