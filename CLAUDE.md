## リポジトリ概要

このdotfilesリポジトリは、macOS/Linux対応のシェル・エディタ・Git環境を管理する個人環境構築ツールです。

### コア構成

- **install.sh**: メインセットアップスクリプト（OS自動判定、Homebrew管理、シンボリックリンク作成）
- **Brewfile**: Homebrew依存パッケージ定義（zsh, git, lazygit, Nerd Font）
- **config/zsh/**: Zsh設定（Oh My Zsh + Powerlevel10k）
- **config/nvim/**: Neovim設定（Lazy.nvim + LSP）
- **config/git/**: Git全体設定

### セットアップコマンド

```bash
# 基本インストール
./install.sh

# Linux環境でNerd Fontも導入
INSTALL_NERD_FONT=1 ./install.sh

# セットアップ完了後
exec zsh
p10k configure
```

### アーキテクチャ上の重要事項

#### Zsh設定の読み込みフロー

1. `~/.zprofile` で `ZDOTDIR=$HOME/.config/zsh` を設定
2. Zshは自動的に `$ZDOTDIR/.zshrc` を読み込む
3. `.zshrc` が Oh My Zsh とプラグインを初期化
4. `aliases.zsh` と `env.d.local/99-local.zsh`（オプション）をソース

**重要**: `~/.zshrc` への直接リンクは不要。ZDOTDIRの仕組みで `~/.config/zsh/.zshrc` が自動読み込みされる。

#### シンボリックリンク管理

`install.sh` の `setup_symlinks()` が以下を作成:

- `~/.p10k.zsh` → `config/zsh/.p10k.zsh`
- `~/.zprofile` → `config/zsh/zprofile`
- `~/.config/zsh/` → `config/zsh/` （ディレクトリごと）
- `~/.config/nvim/` → `config/nvim/`
- `~/.config/git/ignore` → `config/git/ignore`

#### Neovim設定

Lazy.nvimを使用したモジュール化構成:

- **エントリーポイント**: `init.lua`
- **プラグイン管理**: `lua/lazy_setup.lua` が自動ブートストラップ
- **個別設定**: `lua/plugins/` 配下に分離（lsp.lua, treesitter.lua等）
- **LSP対応言語**: Go (gopls), Lua (lua_ls), TypeScript/JavaScript (ts_ls)

#### OS分岐パターン

`install.sh` で `is_mac()` / `is_linux()` 関数を使用して一貫した条件分岐を実施:

- **macOS**: Homebrew自動インストール + `brew bundle`
- **Linux**: オプションでNerd Font手動導入（`INSTALL_NERD_FONT=1`）

### ユーティリティ

```bash
# dotfiles関連のシンボリックリンクを表示
./bin/df-links
```
