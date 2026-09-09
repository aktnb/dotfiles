# ============================================================
# tmux
# ============================================================
# $TERM_PROGRAM をそのままセッション名に使う（未設定なら "main"）
# → ghostty は "ghostty"、vscode は "vscode" セッションに自動アタッチ
#
# tmux 未起動時はここで即座に exec するため、以降のプラグインロード
# （sheldon/p10k/zeno等）は tmux 内の1回だけで済む。ここより後ろに
# 置くと、tmux に入る前の使い捨てシェルでも全プラグインをロードして
# しまい、起動コストが実質2倍になる。
if command -v tmux >/dev/null 2>&1 && [[ -z "$TMUX" ]]; then
  exec tmux new-session -A -s "${TERM_PROGRAM:-main}"
fi

# ============================================================
# Powerlevel10k Instant Prompt
# ============================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
# Sheldon Plugin Manager
# ============================================================
# zeno.zsh がプラグインロード時に `deno cache` を同期実行すると
# 起動のたびに ~30ms 程度かかる（Deno プロセス起動コスト）。
# ここで無効化し、代わりに config/zsh/zeno.zsh 側でバックグラウンド
# 実行する。
export ZENO_DISABLE_EXECUTE_CACHE_COMMAND=1

eval "$(sheldon source)"

# ============================================================
# Completion (compinit)
# ============================================================
# ここまで zsh-completions が fpath に補完定義を追加しただけで、
# compdef を定義する compinit がどこからも呼ばれていなかった。
# 従来は gcloud の補完スクリプト（env.d.local、環境依存）が副作用として
# 初めて compinit を呼んでいたため、gcloud SDK が無い環境では git/docker
# 等の補完も一切効かなかった。ここで明示的に呼び、.zcompdump が24時間
# 以内に更新されていれば compaudit（fpath 全体の権限監査、~20ms）を
# スキップして高速化する。
autoload -Uz compinit
_zcompdump_path="${ZDOTDIR:-$HOME}/.zcompdump"
_zcompdump_stale=(${_zcompdump_path}(Nmh+24))
if (( $#_zcompdump_stale )); then
  compinit
else
  compinit -C
fi
unset _zcompdump_stale

# .zcompdump をバイトコンパイルしておくと、次回起動時の compinit が
# パース済みの .zwc を自動的に読むようになり高速化する。
# .zcompdump 本体より .zwc が古い（＝更新された）場合のみ再コンパイル。
if [[ -f "$_zcompdump_path" && ( ! -f "${_zcompdump_path}.zwc" || "$_zcompdump_path" -nt "${_zcompdump_path}.zwc" ) ]]; then
  zcompile "$_zcompdump_path"
fi
unset _zcompdump_path

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
