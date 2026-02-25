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
fi

