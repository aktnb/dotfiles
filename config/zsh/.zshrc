# ============================================================
# Powerlevel10k Instant Prompt
# ============================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
# Sheldon Plugin Manager
# ============================================================
eval "$(sheldon source)"

# ============================================================
# Powerlevel10k Configuration
# ============================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================
# User Configuration
# ============================================================
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# 共通設定
[[ -f "$ZSH_CONFIG_DIR/aliases.zsh" ]] && source "$ZSH_CONFIG_DIR/aliases.zsh"

# 環境固有設定
for _zsh_local in "$HOME/.config/zsh/env.d.local/"*.zsh(N); do
  source "$_zsh_local"
done
unset _zsh_local

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zeno
[[ -n $ZENO_LOADED && -f "$ZSH_CONFIG_DIR/zeno.zsh" ]] && source "$ZSH_CONFIG_DIR/zeno.zsh"

# tmux
if command -v tmux >/dev/null 2>&1; then
  [ -z "$TMUX" ] && exec tmux new-session -A -s main
fi
