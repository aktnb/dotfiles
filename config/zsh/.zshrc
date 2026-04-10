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
# セッションがなければ新規作成して attach、あれば既存の main に attach する
# GHOSTTY_RESOURCES_DIR が設定されていても quick terminal 判定はできないため、
# exec で zsh を tmux に置き換えることで PTY を一本化し、初回起動の問題を回避する
if command -v tmux >/dev/null 2>&1 && [[ -z "$TMUX" ]]; then
  exec tmux new-session -A -s main
fi
