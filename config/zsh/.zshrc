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
[[ -f "$HOME/.config/zsh/env.d.local/99-local.zsh" ]] && source "$HOME/.config/zsh/env.d.local/99-local.zsh"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zeno
[[ -n $ZENO_LOADED && -f "$ZSH_CONFIG_DIR/zeno.zsh" ]] && source "$ZSH_CONFIG_DIR/zeno.zsh"
