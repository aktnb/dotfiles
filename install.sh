#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"
PRIVATE_MODE=false

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

    # プライベートモードの場合のみ nb の設定をリンク
    if [[ "$PRIVATE_MODE" == true && -f "$DOTFILES_DIR/config/nb/.nbrc" ]]; then
        link "$DOTFILES_DIR/config/nb/.nbrc" "$HOME/.nbrc"
    fi

    if [[ -f "$DOTFILES_DIR/config/zsh/zprofile" ]]; then
        link "$DOTFILES_DIR/config/zsh/zprofile" "$HOME/.zprofile"
    fi

    if [[ -d "$DOTFILES_DIR/config/zsh" ]]; then
        link "$DOTFILES_DIR/config/zsh" ~/.config/zsh
    fi

    # sheldon plugins: プライベートモードで分岐
    if [[ "$PRIVATE_MODE" == true && -f "$DOTFILES_DIR/config/zsh/plugins.private.toml" ]]; then
        link "$DOTFILES_DIR/config/zsh/plugins.private.toml" "$HOME/.config/sheldon/plugins.toml"
    elif [[ -f "$DOTFILES_DIR/config/zsh/plugins.toml" ]]; then
        link "$DOTFILES_DIR/config/zsh/plugins.toml" "$HOME/.config/sheldon/plugins.toml"
    fi

    if [[ -d "$DOTFILES_DIR/config/nvim" ]]; then
        link "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
    fi

    if [[ -d "$DOTFILES_DIR/config/tmux" ]]; then
        link "$DOTFILES_DIR/config/tmux" "$HOME/.config/tmux"
    fi

    # プライベートモードの場合のみ zeno の設定をリンク
    if [[ "$PRIVATE_MODE" == true && -f "$DOTFILES_DIR/config/zeno/config.private.yml" ]]; then
        link "$DOTFILES_DIR/config/zeno/config.private.yml" "$HOME/.config/zeno/config.yml"
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

    # プライベートモードの場合は Brewfile.private も実行
    if [[ "$PRIVATE_MODE" == true && -f "$DOTFILES_DIR/Brewfile.private" ]]; then
        info "running brew bundle (private)"
        brew bundle --file="$DOTFILES_DIR/Brewfile.private"
    fi
}

install_zsh() {
    if command -v zsh >/dev/null 2>&1; then
        info "zsh already installed: $(command -v zsh)"
        return
    fi

    info "zsh not found. installing..."

    if is_mac; then
        if command -v brew >/dev/null 2>&1; then
            info "installing zsh via Homebrew..."
            brew install zsh
        else
            die "Homebrew not found. Cannot install zsh automatically."
        fi
    elif is_linux; then
        if command -v apt-get >/dev/null 2>&1; then
            info "installing zsh via apt-get..."
            sudo apt-get update
            sudo apt-get install -y zsh
        elif command -v yum >/dev/null 2>&1; then
            info "installing zsh via yum..."
            sudo yum install -y zsh
        elif command -v dnf >/dev/null 2>&1; then
            info "installing zsh via dnf..."
            sudo dnf install -y zsh
        elif command -v pacman >/dev/null 2>&1; then
            info "installing zsh via pacman..."
            sudo pacman -S --noconfirm zsh
        else
            die "No supported package manager found. Please install zsh manually."
        fi
    else
        die "Unsupported OS. Please install zsh manually."
    fi

    if command -v zsh >/dev/null 2>&1; then
        info "zsh successfully installed: $(command -v zsh)"
    else
        die "zsh installation failed"
    fi
}

install_linux_packages() {
    if ! is_linux; then
        return
    fi

    info "installing packages for Linux..."

    # neovim のインストール
    if command -v nvim >/dev/null 2>&1; then
        info "neovim already installed: $(command -v nvim)"
    else
        info "installing neovim..."
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y neovim
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y neovim
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y neovim
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm neovim
        else
            warn "No supported package manager found. Please install neovim manually."
        fi
    fi

    # lazygit のインストール
    if command -v lazygit >/dev/null 2>&1; then
        info "lazygit already installed: $(command -v lazygit)"
    else
        info "installing lazygit..."
        if command -v apt-get >/dev/null 2>&1; then
            # Ubuntu/Debian の場合、PPAまたはGitHubリリースから取得
            local LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install lazygit /usr/local/bin
            rm -f lazygit lazygit.tar.gz
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y lazygit || {
                warn "lazygit not available in yum. Installing from GitHub..."
                local LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                tar xf lazygit.tar.gz lazygit
                sudo install lazygit /usr/local/bin
                rm -f lazygit lazygit.tar.gz
            }
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y lazygit || {
                warn "lazygit not available in dnf. Installing from GitHub..."
                local LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                tar xf lazygit.tar.gz lazygit
                sudo install lazygit /usr/local/bin
                rm -f lazygit lazygit.tar.gz
            }
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm lazygit
        else
            warn "No supported package manager found. Please install lazygit manually."
        fi
    fi

    if command -v nvim >/dev/null 2>&1; then
        info "neovim successfully installed: $(command -v nvim)"
    fi
    if command -v lazygit >/dev/null 2>&1; then
        info "lazygit successfully installed: $(command -v lazygit)"
    fi
}

install_nerd_font_linux_optional() {
    if ! is_linux; then
        return
    fi

    if [[ -z "${INSTALL_NERD_FONT:-}" ]]; then
        info "skip Nerd Font installation (set INSTALL_NERD_FONT=1 to install)"
        return
    fi

    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    local base_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
    local fonts=(
        "MesloLGS NF Regular.ttf"
        "MesloLGS NF Bold.ttf"
        "MesloLGS NF Italic.ttf"
        "MesloLGS NF Bold Italic.ttf"
    )

    info "installing MesloLGS NF fonts..."
    for font in "${fonts[@]}"; do
        # URLエンコード: スペースを %20 に変換
        local encoded_font="${font// /%20}"
        local url="$base_url/$encoded_font"
        local dest="$font_dir/$font"

        if [[ -f "$dest" ]]; then
            info "already exists: $font"
        else
            info "downloading: $font"
            curl -fsSL "$url" -o "$dest"
        fi
    done

    if command -v fc-cache >/dev/null 2>&1; then
        info "updating font cache..."
        fc-cache -f "$font_dir"
    else
        warn "fc-cache not found. you may need to refresh font cache manually"
    fi

    info "MesloLGS NF installed to $font_dir"
}


main() {
    # コマンドライン引数の解析
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --private)
                PRIVATE_MODE=true
                info "private mode enabled"
                shift
                ;;
            *)
                warn "unknown option: $1"
                shift
                ;;
        esac
    done

    need_cmd git
    need_cmd curl

    info "DOTFILES_DIR=$DOTFILES_DIR"

    # macOS only
    install_homebrew
    brew_bundle

    # ensure zsh is installed
    install_zsh

    # linux
    install_linux_packages
    install_nerd_font_linux_optional

    # shell environment
    setup_symlinks
    refresh_zsh_comp

    info "done."
}

main "$@"
