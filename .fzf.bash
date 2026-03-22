# Setup fzf (Homebrew: Apple Silicon / Intel, or brew --prefix)
# ---------
if [[ -d /opt/homebrew/opt/fzf ]]; then
  FZF_PREFIX=/opt/homebrew/opt/fzf
elif [[ -d /usr/local/opt/fzf ]]; then
  FZF_PREFIX=/usr/local/opt/fzf
elif command -v brew &>/dev/null; then
  _brew_fzf="$(brew --prefix fzf 2>/dev/null)"
  [[ -n "$_brew_fzf" && -d "$_brew_fzf" ]] && FZF_PREFIX="$_brew_fzf"
  unset _brew_fzf
fi

if [[ -n "$FZF_PREFIX" ]]; then
  if [[ ! "$PATH" == *"$FZF_PREFIX/bin"* ]]; then
    export PATH="$PATH:$FZF_PREFIX/bin"
  fi

  if [[ ! "$MANPATH" == *"$FZF_PREFIX/man"* && -d "$FZF_PREFIX/man" ]]; then
    export MANPATH="$MANPATH:$FZF_PREFIX/man"
  fi

  [[ $- == *i* ]] && [[ -f "$FZF_PREFIX/shell/completion.bash" ]] && source "$FZF_PREFIX/shell/completion.bash" 2>/dev/null

  [[ -f "$FZF_PREFIX/shell/key-bindings.bash" ]] && source "$FZF_PREFIX/shell/key-bindings.bash"
fi
unset FZF_PREFIX
