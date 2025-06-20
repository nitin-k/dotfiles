### oh-my-zsh {
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="nk"

# Red dots are displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

export GPG_TTY=`tty`

plugins=(ssh-agent tmux vundle)

DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh
### }

### zsh {
setopt EXTENDEDGLOB
# Don't fail at the shell level if there's a glob failure. This is useful when
# doing stuff like $(git log -- */file-that-doesnt-exist-anymore).
unsetopt NOMATCH

PATH_DIRECTORIES=(
  $HOME/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/local/bin
  /usr/local/sbin
)

for directory in $PATH_DIRECTORIES; do
  if [ -d "$directory" ]; then
    PATH+=":$directory"
  fi
done

# Eval arbitrary code if a particular program exists
if_program_installed() {
    program=$1
    shift
    which "$program" > /dev/null && eval $* || true
}

export VISUAL=vim
export EDITOR=vim

# Use Vim key bindings to edit the current shell command
bindkey -v
bindkey jk vi-cmd-mode

### history {
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
HOSTNAME_SHORT=$(hostname -s)
mkdir -p "${HOME}/.history/$(date +%Y/%m/%d)"
HISTFILE="${HOME}/.history/$(date +%Y/%m/%d)/$(date +%H.%M.%S)_${HOSTNAME_SHORT}_$$"
HISTSIZE=65536
SAVEHIST=$HISTSIZE

_load_all_shell_history() {
    # Save current history first
    fc -W $HISTFILE

    ALL_HISTORY="$HOME/.history/.all-history"
    [ -f "$ALL_HISTORY" ] && rm -f "$ALL_HISTORY"
    cat ~/.history/**/*(.) > "$ALL_HISTORY"
    # Load *all* shell histories
    fc -R "$ALL_HISTORY"

    _ALL_SHELL_HISTORY_LOADED=1
}

history_incremental_pattern_search_all_history() {
    _load_all_shell_history
    zle end-of-history
    zle history-incremental-pattern-search-backward
}

history_beginning_search_backward_all_history() {
    # We can't reload the entire shell history every time we call this function
    # because successive calls would reload the entire history. Instead, ensure
    # the *entire* shell history only ever gets loaded once.
    if [[ "$_ALL_SHELL_HISTORY_LOADED" != "1" ]] ; then
        _load_all_shell_history
    fi
    zle history-beginning-search-backward
}

bindkey '^R' history_incremental_pattern_search_all_history
bindkey -M isearch '^R' history-incremental-pattern-search-backward
bindkey '^[p' history_beginning_search_backward_all_history
bindkey '^[n' history-beginning-search-forward
bindkey '^W' where-is

zle -N history_incremental_pattern_search_all_history
zle -N history_beginning_search_backward_all_history
### }

### prompt {
case "$(uname -s)" in
  "Darwin")
    alias ls="ls -G"
    alias l="ls -GF"

    export JAVA_HOME=$(/usr/libexec/java_home -v 15)

    # /usr/local/bin should take precedence over /usr/bin
    PATH="/usr/local/bin:$PATH"

    # I don't care about my hostname when I'm on a physical device
    PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
  ;;
esac
### }

### aliases {
alias config="cd ~/git/dotfiles"

alias hisgrep="history | grep"
alias fname="find . -type f -name"
alias vi="vim"
alias duh="du -chs"
alias diff="colordiff"
alias ag="ag --hidden --ignore-case"
#alias filepath='echo `pwd`/`ls "$1"`'
if_program_installed colordiff 'alias diff="colordiff -u"'
if_program_installed tree 'alias tree="tree -C"'
if_program_installed ccat 'alias cat="ccat --bg=dark"'
if_program_installed bat 'alias cat="bat"'
if_program_installed exa 'alias ls="exa"'

# Allow for environment-specific custom aliases/functions
[ -f "$HOME/.localrc" ] && source $HOME/.localrc
[ -f "$HOME/.mutt/gmail.muttrc" ] && alias email="mutt -F $HOME/.mutt/gmail.muttrc"
### }

### exports {
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
### }

### functions {
cd() {
  if [ -z "$@" ] ; then
    return
  fi
  builtin cd "$@" && ls
}

filepath() {
    echo `pwd`/`ls "$1"`
}

extract() {
  if [ -f $1 ] ; then
    case $1 in
    *.tar.bz2)  tar xjf $1      ;;
    *.tar.gz)   tar xzf $1      ;;
    *.bz2)      bunzip2 $1      ;;
    *.rar)      rar x $1        ;;
    *.gz)       gunzip $1       ;;
    *.tar)      tar xf $1       ;;
    *.tbz2)     tar xjf $1      ;;
    *.tgz)      tar xzf $1      ;;
    *.zip)      unzip $1        ;;
    *.Z)        uncompress $1   ;;
    *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file - go home"
  fi
}


# Keep going up directories until you find "$file", or we reach root.
find_parent_file() {
  local file="$1"
  local directory="$PWD"
  local starting_directory="$directory"
  local target=""

  if [ -z "$file" ] ; then
    echo "Please specify a file to find"
  fi

  while [ -d "$directory" ] && [ "$directory" != "/" ]; do
    if [ `find "$directory" -maxdepth 1 -name "$file"` ] ; then
      target="$PWD"
      break
    else
      builtin cd .. && directory="$PWD"
    fi
  done

  builtin cd $starting_directory

  if [ -z "$target" ] ; then
    return 1
  fi

  echo $target
  return 0
}

gw() {
  # cd into the directory so you don't generate .gradle folders everywhere
  builtin cd `find_parent_file gradlew` && ./gradlew $*
  builtin cd -
}

precmd() {
  local tab_label=${PWD/${HOME}/\~} # use 'relative' path
  echo -ne "\e]2;${tab_label}\a" # set window title to full string
}

vif() {
    file=$({ git ls-files -oc --exclude-standard 2>/dev/null || find . -type f } | fzf)
    if [ ! -z "$file" ] ; then
        vim $file
    fi
}

### startup_commands {
ls
### }

### fzf {
if [ -f ~/.fzf.zsh ] ; then
    source ~/.fzf.zsh

    # The fzf shell bindings rewrite your ^R with "fzf-history-widget".
    # I like this widget, but I would like it to load my entire shell history
    # instead of just the current shell's history.
    if [[ "$(bindkey '^R' | cut -f2 -d' ')" == "fzf-history-widget" ]] ; then
        enhanced-fzf-history-widget() {
            _load_all_shell_history
            fzf-history-widget
        }
        zle     -N   enhanced-fzf-history-widget
        bindkey '^R' enhanced-fzf-history-widget
    fi
fi
### }

### LESS
export LESS=-RI

export PATH="/usr/local/opt/freetds@0.91/bin:$PATH"
eval "$(rbenv init -)"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"


export HOMEBREW_ARTIFACTORY_API_TOKEN=AKCp5ekcStqZ13pLqrXht6QDSxYcZ6NawqNYrgxTPSsYyM8DNCYeqkVdEpuzRHoQDjLtYg5TA
export HOMEBREW_ARTIFACTORY_API_USER=skanigicharla
export PATH="/usr/local/opt/ruby/bin:$PATH"

source $HOME/.local_aliases

#export NVM_DIR="$HOME/.nvm"
#  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
