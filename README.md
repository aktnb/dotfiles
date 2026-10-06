# dotfiles

macOS 向けのシェル・エディタ・ターミナル・Git 環境を管理する個人用 dotfiles です。セットアップは Homebrew によるパッケージ導入と設定ファイルのシンボリックリンク作成で行います。

## 管理している設定

| ツール | 内容 |
| --- | --- |
| Zsh | sheldon、Powerlevel10k、補完、入力候補、構文ハイライト、zeno、ローカル環境設定 |
| Neovim | lazy.nvim、Mason、LSP、補完、Treesitter、neo-tree、lazygit 連携 |
| tmux | `Ctrl-a` プリフィックス、Vim 風のペイン操作、popup、タイトル・ステータスバー |
| Ghostty | フォント・テーマ・透過、終了確認の無効化、tmux 向けキーバインド |
| lazygit | コミット種別・スコープ・絵文字を選択するカスタムコマンド |
| Git | グローバル ignore ファイル |
| cmux | 匿名テレメトリーを無効にする設定ファイル |
| iTerm2 | 設定 plist |

cmux と iTerm2 の設定ファイルはリポジトリで管理していますが、現在の `install.sh` では自動適用しません。

## セットアップ

Git と curl が利用できる macOS 環境で実行します。

```bash
git clone https://github.com/aktnb/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Homebrew・Brewfile のパッケージ導入と設定ファイルのリンク作成
./install.sh
```

既存のリンク先が通常のディレクトリの場合は、`.backup.<日時>` に退避します。既存の通常ファイルやシンボリックリンクは置き換えるため、必要な設定は事前にバックアップしてください。

### 自動作成されるリンク

| リポジトリ内のパス | リンク先 |
| --- | --- |
| `config/zsh/zshenv` | `~/.zshenv` |
| `config/zsh/` | `~/.config/zsh` |
| `config/zsh/.p10k.zsh` | `~/.p10k.zsh` |
| `config/sheldon/plugins.toml` | `~/.config/sheldon/plugins.toml` |
| `config/nvim/` | `~/.config/nvim` |
| `config/tmux/` | `~/.config/tmux` |
| `config/ghostty/config` | `~/.config/ghostty/config` |
| `config/lazygit/config.yml` | `~/.config/lazygit/config.yml` |
| `config/git/ignore` | `~/.config/git/ignore` |

`config/zeno/config.yml` が存在する場合も `~/.config/zeno/config.yml` へリンクしますが、現在このファイルはリポジトリに含まれていません。

### セットアップ後

```bash
# zsh をデフォルトシェルに設定
chsh -s "$(command -v zsh)"
```

新しいターミナルを開くと、tmux が利用できる場合は自動的にセッションへ接続します。Powerlevel10k の設定は同梱されています。変更したい場合は `p10k configure` を実行します。

Neovim は Brewfile に含まれないため、使用する場合は別途インストールしてください。

```bash
brew install neovim
nvim
```

初回起動時に lazy.nvim がプラグインを導入し、LSP 設定の読み込み時に Mason が設定済みの言語サーバーを導入します。

## リポジトリ構成

| パス | 内容 |
| --- | --- |
| `install.sh` | Homebrew・パッケージ導入、リンク作成、補完キャッシュ削除 |
| `Brewfile` | Homebrew のパッケージ定義 |
| `config/zsh/` | `.zshrc`、`.zprofile`、`zshenv`、`.p10k.zsh`、`aliases.zsh`、`zeno.zsh`、`env.d.local/` |
| `config/sheldon/plugins.toml` | Zsh プラグイン定義 |
| `config/nvim/` | `init.lua`、`lazy-lock.json`、`ftplugin/`、`lua/` |
| `config/nvim/lua/` | `options.lua`、`keymaps.lua`、`lazy_setup.lua`、`plugins/`、`lsp_servers_local.lua.sample` |
| `config/tmux/tmux.conf` | tmux 設定 |
| `config/ghostty/config` | Ghostty 設定 |
| `config/lazygit/config.yml` | lazygit のカスタムコマンド |
| `config/git/ignore` | グローバル gitignore |
| `config/cmux/settings.json` | cmux 設定（手動適用） |
| `config/iterm2/com.googlecode.iterm2.plist` | iTerm2 設定（手動適用） |
| `docs/keybind.md` | キーバインド一覧 |
| `bin/df-links` / `bin/df-unlink` | リンク確認・削除ユーティリティ |

## Zsh 設定の仕組み

1. `~/.zshenv` で `ZDOTDIR=$HOME/.config/zsh` と `XDG_CONFIG_HOME` を設定します。Apple Silicon の Homebrew と Rust/Cargo の環境設定も、存在する場合に読み込みます。
2. Zsh が `$ZDOTDIR/.zshrc` を読み込みます。`~/.zshrc` への直接リンクは不要です。
3. tmux が利用でき、まだ tmux 内でなければ、`TERM_PROGRAM` をセッション名として作成・接続します。未設定の場合は `main` を使います。
4. tmux 内のシェルで sheldon によるプラグイン読み込み、`compinit` による補完初期化、Powerlevel10k の設定読み込みを行います。
5. `aliases.zsh`、`env.d.local/*.zsh`、`~/.fzf.zsh`（存在する場合）、`zeno.zsh`（zeno ロード済みの場合）を読み込みます。

sheldon は Powerlevel10k、zsh-completions、zsh-autosuggestions、zeno.zsh、fast-syntax-highlighting を管理します。

詳細は [Zsh 設定](./config/zsh/README.md) を参照してください。

## インストールされるパッケージ

[Brewfile](./Brewfile) で管理しているパッケージです。

| 種別 | パッケージ |
| --- | --- |
| CLI | zsh、git、lazygit、fzf、sheldon、deno、tmux |
| GUI | Ghostty、Raycast |
| フォント | Meslo LG Nerd Font（`font-meslo-lg-nerd-font`） |

Neovim、cmux、iTerm2 は別途導入します。

## tmux・Ghostty・lazygit

tmux のプリフィックスは `Ctrl-a` です。`prefix + g` で lazygit、`prefix + e` で Neovim、`prefix + s` でスクラッチターミナルを popup 表示します。

Ghostty は TokyoNight テーマと MesloLGS NF フォントを使用します。`confirm-close-surface = false` で終了確認を無効にし、`Option + Space` で表示切り替え、`Ctrl-d` / `Ctrl-Shift-d` で tmux のペイン分割、`Shift-Enter` で LF を送信します。

lazygit では files コンテキストの `Ctrl-c` で、コミット種別・スコープ・メッセージ・絵文字を指定してコミットできます。

詳細は [tmux 設定](./config/tmux/README.md) と [キーバインド一覧](./docs/keybind.md) を参照してください。

## Neovim 設定

標準で有効な LSP は次のとおりです。

| 言語 | サーバー |
| --- | --- |
| Lua | `lua_ls` |
| YAML | `yamlls` |
| JSON | `jsonls` |

Go や TypeScript/JavaScript などを追加する場合は、ローカル設定のサンプルをコピーし、必要なサーバーのコメントアウトを外します。

```bash
cp ~/.config/nvim/lua/lsp_servers_local.lua.sample \
   ~/.config/nvim/lua/lsp_servers_local.lua
```

`lsp_servers_local.lua` の `servers` は標準設定とマージされ、ローカル設定が優先されます。このファイルは Git 管理対象外です。

詳細は [Neovim 設定](./config/nvim/README.md) と [LSP 設定ガイド](./config/nvim/README_LSP.md) を参照してください。

## ローカル環境専用の設定

`~/.config/zsh/env.d.local/` 配下の `*.zsh` は名前順に読み込まれます。

```bash
# 例: ~/.config/zsh/env.d.local/99-local.zsh
export MY_CUSTOM_VAR="value"
alias myalias="command"
```

現在の `.gitignore` は `99-local.zsh` を除外しています。他のファイル名を使う場合は、個人設定をコミットしないよう `.git/info/exclude` などに除外設定を追加してください。

## ユーティリティ

```bash
# ホーム配下で、リンク先に "dotfiles" を含むリンクを一覧表示
./bin/df-links

# スクリプトに列挙された設定リンクを削除（~/.zshenv は確認あり）
./bin/df-unlink
```

`df-unlink` はリンクを削除し、バックアップが見つかれば復元します。現在は Ghostty・tmux・lazygit のリンクが削除対象に含まれていないため、これらの解除は手動で行ってください。
