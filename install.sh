#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

info() {
  printf "\033[1;32m[dotfiles]\033[0m %s\n" "$*"
}

warn() {
  printf "\033[1;33m[dotfiles]\033[0m %s\n" "$*"
}

die() {
  printf "\033[1;31m[dotfiles]\033[0m %s\n" "$*"
  exit 1
}

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "必要なコマンド '$1' が見つかりません。先にインストールしてください。"
}

is_mac() {
    [[ "$OS" == "Darwin" ]]
}

link() {
    src="$1"
    dst="$2"
    mkdir -p "$(dirname "$dst")"

    # 既存のディレクトリがある場合は退避
    if [[ -d "$dst" && ! -L "$dst" ]]; then
        local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
        mv "$dst" "$backup"
        warn "existing directory moved: $dst -> $backup"
    fi

    ln -snf "$src" "$dst"
    info "linked: $dst"
}

git_clone_or_update() {
    local repo="$1"
    local dest="$2"

    if [[ -d "$dest/.git" ]]; then
        info "update: $dest"
        git -C "$dest" fetch --depth=1 origin >/dev/null 2>&1 || true
        git -C "$dest" reset --hard origin/HEAD >/dev/null 2>&1 || true
    else
        info "clone: $repo -> $dest"
        mkdir -p "$(dirname "$dest")"
        git clone --depth=1 "$repo" "$dest"
    fi
}

setup_symlinks() {
    if [[ -f "$DOTFILES_DIR/config/zsh/.p10k.zsh" ]]; then
        link "$DOTFILES_DIR/config/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    fi

    if [[ -f "$DOTFILES_DIR/config/git/ignore" ]]; then
        link "$DOTFILES_DIR/config/git/ignore" "$HOME/.config/git/ignore"
    fi

    if [[ -d "$DOTFILES_DIR/config/zsh" ]]; then
        link "$DOTFILES_DIR/config/zsh" ~/.config/zsh
    fi

    if [[ -f "$DOTFILES_DIR/config/sheldon/plugins.toml" ]]; then
        link "$DOTFILES_DIR/config/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml"
    fi

    if [[ -d "$DOTFILES_DIR/config/nvim" ]]; then
        link "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
    fi

    if [[ -f "$DOTFILES_DIR/config/zeno/config.yml" ]]; then
        link "$DOTFILES_DIR/config/zeno/config.yml" "$HOME/.config/zeno/config.yml"
    fi

    if [[ -f "$DOTFILES_DIR/config/ghostty/config" ]]; then
        link "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"
    fi
}

refresh_zsh_comp() {
    # 補完キャッシュ再生成
    rm -f "$HOME/.zcompdump" "$HOME/.zcompdump.zwc" 2>/dev/null || true
    info "zsh completion cache cleared (~/.zcompdump*)"
}

install_homebrew() {
    if [[ -f "$DOTFILES_DIR/config/zsh/zshenv" ]]; then
        link "$DOTFILES_DIR/config/zsh/zshenv" "$HOME/.zshenv"
    fi

    if command -v brew >/dev/null 2>&1; then
        info "Homebrew already installed"
        return
    fi

    info "installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # PATH 反映（Apple Silicon / Intel 両対応）
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    else
        die "brew installed but not found in PATH"
    fi
}

brew_bundle() {
    if ! command -v brew >/dev/null 2>&1; then
        warn "brew not found. skip brew bundle."
        return
    fi

    if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
        info "running brew bundle"
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    else
        warn "Brewfile not found. skip."
    fi
}

install_zsh() {
    if command -v zsh >/dev/null 2>&1; then
        info "zsh already installed: $(command -v zsh)"
        return
    fi

    info "zsh not found. installing..."

    if command -v brew >/dev/null 2>&1; then
        info "installing zsh via Homebrew..."
        brew install zsh
    else
        die "Homebrew not found. Cannot install zsh automatically."
    fi

    if command -v zsh >/dev/null 2>&1; then
        info "zsh successfully installed: $(command -v zsh)"
    else
        die "zsh installation failed"
    fi
}


main() {
    # コマンドライン引数の解析
    while [[ $# -gt 0 ]]; do
        warn "unknown option: $1"
        shift
    done

    need_cmd git
    need_cmd curl

    info "DOTFILES_DIR=$DOTFILES_DIR"

    # macOS only
    install_homebrew
    brew_bundle

    # ensure zsh is installed
    install_zsh

    # shell environment
    setup_symlinks
    refresh_zsh_comp

    info "done."
}

main "$@"
