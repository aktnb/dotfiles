# ~/.config/zsh/aliases.zsh

if command -v nvim >/dev/null 2>&1; then
    alias vim="nvim"
fi

if command -v lazygit >/dev/null 2>&2; then
    alias lg="lazygit"
fi

alias git-clean="git fetch --prune && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -d"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias lsl='ls -l'
alias lsa='ls -a'
alias lsla='ls -la'
