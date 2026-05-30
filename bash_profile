eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

alias ll='eza -lg --git'
alias la='eza -a'
alias l='eza -F'
alias e='nvim'
alias ssh='export TERM=xterm-256color && ssh'
alias update='brew update && brew upgrade && rustup update'

PS1='\[\033[01;33m\]󰽰 \[\033[00m\]'

[ -f "$HOME/.env.sh" ] && source "$HOME/.env.sh"
