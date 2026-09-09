# ============================================================
# Zeno Configuration
# ============================================================
export ZENO_HOME=~/.config/zeno
export ZENO_GIT_CAT="bat --color=always"

if [[ -n $ZENO_LOADED ]]; then
    # zsh-autosuggestions が未確定の履歴予測を消さずに
    # zeno-auto-snippet-and-accept-line を実行してしまい、
    # 実行内容は正しいまま画面表示だけ予測込みに見えるのを防ぐ
    typeset -ga ZSH_AUTOSUGGEST_CLEAR_WIDGETS
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(zeno-auto-snippet-and-accept-line)

    bindkey ' ' zeno-auto-snippet

    bindkey '^m' zeno-auto-snippet-and-accept-line

    bindkey '^xx' zeno-insert-snippet

    bindkey '^x ' zeno-insert-space
    bindkey '^x^m' accept-line
    bindkey '^x^z' zeno-toggle-auto-snippet

    bindkey '^xp' zeno-preprompt
    bindkey '^xs' zeno-preprompt-snippet

    bindkey '^r' zeno-smart-history-selection

    # tmux セッション名を保持したまま ghq-cd する
    function _zeno_ghq_cd_preserve_session() {
        local session_name
        [[ -n "$TMUX" ]] && session_name=$(tmux display-message -p '#S')
        zle zeno-ghq-cd
        local ret=$?
        [[ -n "$TMUX" && -n "$session_name" ]] && tmux rename-session -- "$session_name"
        return $ret
    }
    zle -N _zeno_ghq_cd_preserve_session
    bindkey '^g' _zeno_ghq_cd_preserve_session

    # deno cache をバックグラウンドで実行し、シェル起動をブロックしない
    # （ZENO_DISABLE_EXECUTE_CACHE_COMMAND=1 で同期実行を無効化した分の代替）
    if (( $+commands[deno] )) && [[ -n $ZENO_ROOT ]]; then
        ( command deno cache --unstable-byonm --no-lock --no-check -- "${ZENO_ROOT}/src/cli.ts" &>/dev/null & ) &!
    fi
fi

