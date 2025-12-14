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
is_linux() {
    [[ "$OS" == "Linux" ]]
}

link() {
    src="$1"
    dst="$2"
    mkdir -p "$(dirname "$dst")"
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

install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        info "oh-my-zsh is already installed: $HOME/.oh-my-zsh"
        return
    fi

    info "installing oh-my-zsh..."
    if [[ -f "$HOME/.zshrc" ]]; then
        local backup="$HOME/.zshrc.pre-ohmyzsh.$(date +%Y%m%d%H%M%S)"
        cp "$HOME/.zshrc" "$backup"
        warn "make a backup: $backup"
    fi

    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_plugins_and_theme() {
  local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  git_clone_or_update "https://github.com/romkatv/powerlevel10k.git" \
    "$ZSH_CUSTOM/themes/powerlevel10k"

  git_clone_or_update "https://github.com/zsh-users/zsh-completions.git" \
    "$ZSH_CUSTOM/plugins/zsh-completions"

  git_clone_or_update "https://github.com/zsh-users/zsh-autosuggestions.git" \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

  git_clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
}

setup_symlinks() {
    if [[ -f "$DOTFILES_DIR/config/zsh/.p10k.zsh" ]]; then
        link "$DOTFILES_DIR/config/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    fi

    if [[ -f "$DOTFILES_DIR/config/git/ignore" ]]; then
        link "$DOTFILES_DIR/config/git/ignore" "$HOME/.config/git/ignore"
    fi

    if [[ -f "$DOTFILES_DIR/config/zsh/zprofile" ]]; then
        link "$DOTFILES_DIR/config/zsh/zprofile" "$HOME/.zprofile"
    fi

    if [[ -d "$DOTFILES_DIR/config/zsh" ]]; then
        link "$DOTFILES_DIR/config/zsh" ~/.config/zsh
    fi

    if [[ -d "$DOTFILES_DIR/config/nvim" ]]; then
        link "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
    fi
}

refresh_zsh_comp() {
    # 補完キャッシュ再生成
    rm -f "$HOME/.zcompdump" "$HOME/.zcompdump.zwc" 2>/dev/null || true
    info "zsh completion cache cleared (~/.zcompdump*)"
}

install_homebrew() {
    if ! is_mac; then
        info "not macOS. skip Homebrew."
        return
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
    if ! is_mac; then
        return
    fi

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

install_nerd_font_linux_optional() {
    # brew 不使用のため、Linuxのみ自動導入オプションを用意
    # macOSはGUIでフォント入れるのが安全なのでスキップ
    if ! is_linux; then
        return
    fi

    if [[ "${INSTALL_NERD_FONT:-0}" != "1" ]]; then
        warn "Nerd Font (FiraCode) は未インストールです。必要なら INSTALL_NERD_FONT=1 ./install.sh で導入します。"
        return
    fi

    need_cmd curl
    need_cmd unzip
    need_cmd fc-cache

    info "installing FiraCode Nerd Font (Linux)..."
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"
    local tmp
    tmp="$(mktemp -d)"
    curl -fsSL -o "$tmp/FiraCode.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    unzip -o "$tmp/FiraCode.zip" -d "$font_dir" >/dev/null
    fc-cache -fv >/dev/null
    rm -rf "$tmp"
    info "FiraCode Nerd Font installed. Terminal側のフォント設定も忘れずに。"
}


main() {
    need_cmd git
    need_cmd curl

    info "DOTFILES_DIR=$DOTFILES_DIR"

    # macOS only
    install_homebrew
    brew_bundle

    # linux
    install_nerd_font_linux_optional

    # shell environment
    install_oh_my_zsh
    install_plugins_and_theme
    setup_symlinks
    refresh_zsh_comp

    info "done."
    info "next: exec zsh && p10k configure"
}

main "$@"
