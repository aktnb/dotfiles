# ============================================================
# Zeno Configuration
# ============================================================
export ZENO_HOME=~/.config/zeno
export ZENO_GIT_CAT="bat --color=always"

if [[ -n $ZENO_LOADED ]]; then
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
fi

