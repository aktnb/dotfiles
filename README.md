# dotfiles

macOS/Linux 対応のシェル・エディタ・Git 環境を管理する個人環境構築ツールです。

## 機能

- **Zsh 環境**: sheldon + Powerlevel10k + 便利なプラグイン
- **Neovim**: Lazy.nvim + LSP 設定（Go, Lua, TypeScript/JavaScript, YAML, JSON 対応）
- **ターミナル**: iTerm2 設定
- **Git 設定**: グローバルな ignore ファイル
- **パッケージ管理**: Homebrew（macOS）による依存パッケージの自動インストール

## セットアップ

### macOS

```bash
# リポジトリをクローン
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 基本インストール（Homebrew + パッケージ + 設定ファイル）
./install.sh

# プライベート設定も含めてインストール
./install.sh --private
```

### Linux

```bash
# リポジトリをクローン
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 基本インストール（Nerd Fontなし）
./install.sh

# MesloLGS NF フォントも含めてインストール
INSTALL_NERD_FONT=1 ./install.sh

# プライベート設定も含めてインストール
./install.sh --private

# Nerd Font + プライベート設定
INSTALL_NERD_FONT=1 ./install.sh --private
```

**自動的にインストールされるパッケージ:**
- zsh
- git
- neovim
- lazygit
- fzf
- sheldon
- deno
- cmux

**対応パッケージマネージャー:**
- apt-get (Ubuntu/Debian)
- yum (CentOS/RHEL)
- dnf (Fedora)
- pacman (Arch Linux)

### Linux でのフォント設定（zsh + Powerlevel10k 用）

`INSTALL_NERD_FONT=1` でフォントをインストールした後、ターミナルエミュレータの設定でフォントを **MesloLGS NF** に変更する必要があります。

#### GNOME Terminal

1. ターミナルを開く
2. メニューから **Preferences**（設定）を選択
3. 使用しているプロファイルを選択
4. **Text** タブを開く
5. **Custom font** にチェックを入れる
6. フォント選択で **MesloLGS NF Regular** を選択（サイズは 12-14 を推奨）

#### Konsole (KDE)

1. **Settings** → **Edit Current Profile**
2. **Appearance** タブを開く
3. **Font** セクションで **Select Font** をクリック
4. **MesloLGS NF** を選択

#### Alacritty

`~/.config/alacritty/alacritty.yml`（または `alacritty.toml`）を編集:

```yaml
font:
  normal:
    family: MesloLGS NF
  size: 13.0
```

#### kitty

`~/.config/kitty/kitty.conf` を編集:

```conf
font_family      MesloLGS NF Regular
bold_font        MesloLGS NF Bold
italic_font      MesloLGS NF Italic
bold_italic_font MesloLGS NF Bold Italic
font_size        13.0
```

#### Tilix

1. **Preferences** を開く
2. **Profiles** を選択
3. 使用しているプロファイルの **Appearance** タブを開く
4. **Custom font** にチェックを入れる
5. **MesloLGS NF** を選択

#### フォント設定の確認

ターミナルを再起動後、以下のコマンドでフォントが正しく表示されるか確認できます:

```bash
echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
```

正しく設定されていれば、記号が正しく表示されます。

## セットアップ後の設定

### zsh をデフォルトシェルにする

インストール完了後、zsh をデフォルトシェルに設定することを推奨します。

#### macOS / Linux 共通

```bash
# zsh のパスを確認
which zsh

# zsh をデフォルトシェルに設定
chsh -s $(which zsh)
```

設定後、ターミナルを再起動すると zsh が起動します。

#### 注意事項

- `chsh` コマンドは通常、パスワードの入力が必要です
- macOS では `/bin/zsh` がデフォルトで利用可能ですが、Homebrew でインストールした zsh (`/opt/homebrew/bin/zsh` または `/usr/local/bin/zsh`) を使用することも可能です
- 一部の Linux ディストリビューションでは、`/etc/shells` に zsh のパスが登録されていない場合があります。その場合は以下のコマンドで追加してください:

```bash
# /etc/shells に zsh を追加（必要な場合のみ）
which zsh | sudo tee -a /etc/shells
```

#### 設定の確認

```bash
# 現在のシェルを確認
echo $SHELL

# 実際に動作しているシェルを確認
ps -p $$
```

### Powerlevel10k の初期設定

初回起動時、または以下のコマンドで Powerlevel10k の設定ウィザードを実行できます:

```bash
p10k configure
```

## install.sh のオプション

| オプション/環境変数   | 説明                                                                                                              |
| --------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `--private`           | プライベート設定を有効化します。`Brewfile.private`、`plugins.private.toml` のプライベート設定を読み込みます。 |
| `INSTALL_NERD_FONT=1` | Linux 環境で MesloLGS NF フォントをインストールします。macOS では Brewfile 経由でインストールされるため不要です。 |

## リポジトリ構成

```
dotfiles/
├── install.sh           # メインセットアップスクリプト
├── Brewfile             # Homebrew依存パッケージ定義（macOS用）
├── Brewfile.private     # プライベート用Brewfile（オプション、gitignore対象）
├── config/
│   ├── zsh/             # Zsh設定
│   │   ├── .zshrc       # メイン設定ファイル
│   │   ├── .p10k.zsh    # Powerlevel10k テーマ設定
│   │   ├── zprofile     # ZDOTDIR設定
│   │   ├── aliases.zsh  # エイリアス定義
│   │   ├── plugins.toml # sheldonプラグイン定義
│   │   └── plugins.private.toml  # プライベート用プラグイン（オプション）
│   ├── nvim/            # Neovim設定
│   │   ├── init.lua
│   │   └── lua/
│   │       ├── lazy_setup.lua
│   │       └── plugins/
│   ├── tmux/            # tmux設定
│   ├── iterm2/          # iTerm2設定
│   ├── zeno/            # zenoスニペット設定（オプション）
│   └── git/
│       └── ignore       # グローバルgitignore
└── bin/
    ├── df-links         # シンボリックリンク表示ユーティリティ
    └── df-unlink        # シンボリックリンク削除ユーティリティ
```

## Zsh 設定の仕組み

1. `~/.zprofile` で `ZDOTDIR=$HOME/.config/zsh` を設定
2. Zsh が自動的に `$ZDOTDIR/.zshrc` を読み込む
3. `.zshrc` が sheldon を使ってプラグインを初期化
   - sheldon は `~/.config/sheldon/plugins.toml` から設定を読み込む
   - Powerlevel10k テーマ、zsh-autosuggestions、fast-syntax-highlighting などを管理
4. `aliases.zsh`、`zeno.zsh`、`env.d.local/99-local.zsh`（オプション）を読み込み

**注意**: `~/.zshrc` への直接リンクは不要です。ZDOTDIR の仕組みで `~/.config/zsh/.zshrc` が自動的に読み込まれます。

## ユーティリティ

```bash
# dotfiles関連のシンボリックリンクを一覧表示
./bin/df-links

# dotfiles関連のシンボリックリンクを削除
./bin/df-unlink
```

## インストールされるパッケージ（macOS）

Brewfile で管理されているパッケージ：

### CLI ツール
- **zsh**: シェル
- **git**: バージョン管理
- **lazygit**: Git TUI
- **fzf**: ファジーファインダー
- **sheldon**: Zsh プラグインマネージャー
- **deno**: JavaScript / TypeScript ランタイム
- **cmux**: ターミナルマルチプレクサ

### GUI アプリケーション
- **iTerm2**: ターミナルエミュレータ
- **Raycast**: ランチャー

## Neovim 設定

詳細は [config/nvim/README.md](./config/nvim/README.md) を参照してください。

### LSP 対応言語

- Go (`gopls`)
- Lua (`lua_ls`)
- TypeScript/JavaScript (`ts_ls`)
- YAML (`yamlls`)
- JSON (`jsonls`)

### プラグイン管理

Lazy.nvim を使用したモジュール化構成。プラグインは `lua/plugins/` 配下に分離して管理されています。

## カスタム機能

### zeno スニペット

zeno を使用してコマンドスニペットを管理。`~/.config/zeno/config.yml` で独自のスニペットを定義できます。

- `Space`: スニペット自動展開
- `Ctrl-x x`: スニペット挿入
- `Ctrl-r`: 履歴検索（zeno 拡張版）

## カスタマイズ

### ローカル環境専用の設定

`~/.config/zsh/env.d.local/99-local.zsh` を作成すると、個人環境専用の設定を追加できます（git にはコミットされません）。

```bash
# 例: ~/.config/zsh/env.d.local/99-local.zsh
export MY_CUSTOM_VAR="value"
alias myalias="command"
```

### プライベート設定

`./install.sh --private` を使用すると、以下のプライベート設定ファイルを有効化できます：

- `Brewfile.private`: 個人的な Homebrew パッケージ
- `config/zsh/plugins.private.toml`: 個人的な zsh プラグイン
- `config/zeno/config.private.yml`: zeno のプライベートスニペット
