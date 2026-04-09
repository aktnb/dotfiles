# dotfiles

macOS 向けのシェル・エディタ・Git 環境を管理する個人環境構築ツールです。

## 機能

- **Zsh 環境**: sheldon + Powerlevel10k + 便利なプラグイン
- **Neovim**: Lazy.nvim + LSP 設定（Go, Lua, TypeScript/JavaScript, YAML, JSON 対応）
- **tmux**: カスタムキーバインド・外観設定
- **ターミナル**: Ghostty 設定
- **Git 設定**: グローバルな ignore ファイル
- **パッケージ管理**: Homebrew による依存パッケージの自動インストール

## セットアップ

```bash
# リポジトリをクローン
git clone https://github.com/aktnb/dotfiles.git ~/dotfiles
cd ~/dotfiles

# インストール（Homebrew + パッケージ + 設定ファイル）
./install.sh
```

### セットアップ後

```bash
# zsh をデフォルトシェルに設定
chsh -s $(which zsh)

# Powerlevel10k の初期設定
p10k configure
```

## リポジトリ構成

```
dotfiles/
├── install.sh           # メインセットアップスクリプト
├── Brewfile             # Homebrew 依存パッケージ定義
├── config/
│   ├── zsh/             # Zsh 設定
│   │   ├── .zshrc       # メイン設定ファイル
│   │   ├── .p10k.zsh    # Powerlevel10k テーマ設定
│   │   ├── .zprofile    # zsh プロファイル
│   │   ├── zshenv       # ZDOTDIR 設定（~/.zshenv へシンボリックリンク）
│   │   ├── aliases.zsh  # エイリアス定義
│   │   ├── zeno.zsh     # zeno スニペット設定
│   │   └── env.d.local/ # ローカル環境専用設定置き場（git 管理外）
│   ├── sheldon/
│   │   └── plugins.toml # sheldon プラグイン定義
│   ├── nvim/            # Neovim 設定
│   │   ├── init.lua
│   │   └── lua/
│   │       ├── lazy_setup.lua
│   │       └── plugins/
│   ├── tmux/            # tmux 設定
│   │   └── tmux.conf
│   ├── ghostty/         # Ghostty ターミナル設定
│   │   └── config
│   ├── zeno/            # zeno スニペット設定（オプション）
│   └── git/
│       └── ignore       # グローバル gitignore
└── bin/
    ├── df-links         # シンボリックリンク表示ユーティリティ
    └── df-unlink        # シンボリックリンク削除ユーティリティ
```

## Zsh 設定の仕組み

1. `~/.zshenv`（`config/zsh/zshenv` へのシンボリックリンク）で `ZDOTDIR=$HOME/.config/zsh` を設定
2. Zsh が自動的に `$ZDOTDIR/.zshrc` を読み込む
3. `.zshrc` が sheldon を使ってプラグインを初期化
   - sheldon は `~/.config/sheldon/plugins.toml` から設定を読み込む
   - Powerlevel10k テーマ、zsh-autosuggestions、fast-syntax-highlighting などを管理
4. `aliases.zsh`、`zeno.zsh`、`env.d.local/*.zsh`（オプション）を読み込み

**注意**: `~/.zshrc` への直接リンクは不要です。ZDOTDIR の仕組みで `~/.config/zsh/.zshrc` が自動的に読み込まれます。

## インストールされるパッケージ

Brewfile で管理されているパッケージ：

### CLI ツール
- **zsh**: シェル
- **git**: バージョン管理
- **lazygit**: Git TUI
- **fzf**: ファジーファインダー
- **sheldon**: Zsh プラグインマネージャー
- **deno**: JavaScript / TypeScript ランタイム
- **rtk**: トークン最適化 CLI プロキシ

### GUI アプリケーション
- **Ghostty**: ターミナルエミュレータ
- **Raycast**: ランチャー

## tmux 設定

詳細は [config/tmux/README.md](./config/tmux/README.md) を参照してください。

## Neovim 設定

詳細は [config/nvim/README.md](./config/nvim/README.md) を参照してください。

### LSP 対応言語

- Go (`gopls`)
- Lua (`lua_ls`)
- TypeScript/JavaScript (`ts_ls`)
- YAML (`yamlls`)
- JSON (`jsonls`)

## カスタマイズ

### ローカル環境専用の設定

`~/.config/zsh/env.d.local/` 配下に `*.zsh` ファイルを作成すると、個人環境専用の設定を追加できます（git にはコミットされません）。

```bash
# 例: ~/.config/zsh/env.d.local/99-local.zsh
export MY_CUSTOM_VAR="value"
alias myalias="command"
```

## ユーティリティ

```bash
# dotfiles 関連のシンボリックリンクを一覧表示
./bin/df-links

# dotfiles 関連のシンボリックリンクを削除
./bin/df-unlink
```
