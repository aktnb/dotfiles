# Zsh 設定

## ファイル構成

| ファイル | 説明 |
| --- | --- |
| `zshenv` | `~/.zshenv` へのリンク。`ZDOTDIR` を設定し、Homebrew の PATH を通す |
| `.zprofile` | Homebrew の環境変数を設定 |
| `.zshrc` | メイン設定。sheldon・Powerlevel10k・各設定ファイルの読み込み |
| `.p10k.zsh` | Powerlevel10k テーマ設定（`p10k configure` で生成） |
| `aliases.zsh` | エイリアス定義 |
| `zeno.zsh` | zeno のキーバインド設定 |
| `env.d.local/` | ローカル環境専用設定置き場（git 管理外） |

## 読み込みフロー

```
~/.zshenv (→ zshenv)
  └─ ZDOTDIR=$HOME/.config/zsh を設定

$ZDOTDIR/.zshrc (→ .zshrc)
  ├─ sheldon source    # プラグイン読み込み
  ├─ .p10k.zsh         # Powerlevel10k
  ├─ aliases.zsh       # エイリアス
  ├─ env.d.local/*.zsh # ローカル設定（存在する場合）
  ├─ ~/.fzf.zsh        # fzf（存在する場合）
  └─ zeno.zsh          # zeno（ロード済みの場合）
```

`~/.zshrc` への直接リンクは不要です。`ZDOTDIR` の仕組みで `$ZDOTDIR/.zshrc` が自動的に読み込まれます。

## エイリアス

| エイリアス | コマンド | 条件 |
| --- | --- | --- |
| `vim` | `nvim` | nvim がインストール済みの場合 |
| `lg` | `lazygit` | lazygit がインストール済みの場合 |
| `git-clean` | リモートで削除されたブランチをローカルからも削除 | 常時 |
| `..` / `...` / `....` | 1〜3段階上のディレクトリへ移動 | 常時 |

## zeno キーバインド

| キー | 動作 |
| --- | --- |
| `Space` | スニペット自動展開 |
| `Enter` | スニペット展開 + 実行 |
| `Ctrl-x x` | スニペット挿入 |
| `Ctrl-r` | 履歴検索 |
| `Ctrl-g` | ghq リポジトリへ移動 |

スニペット定義は `~/.config/zeno/config.yml` で管理しています。

## ローカル環境専用設定

`env.d.local/` 配下に `*.zsh` ファイルを置くと自動で読み込まれます（git 管理外）。

```bash
# 例: env.d.local/99-local.zsh
export MY_TOKEN="..."
alias myalias="command"
```

ファイルはアルファベット順に読み込まれるため、数字プレフィックスで順序を制御できます（例: `10-path.zsh`, `99-local.zsh`）。
