# Neovim 設定

Lazy.nvim を使用したモジュール化構成の Neovim 設定です。

## 目次

- [プラグイン一覧](#プラグイン一覧)
- [キーバインド一覧](#キーバインド一覧)
- [LSP 設定](./README_LSP.md)

---

## プラグイン一覧

### プラグインマネージャー

| プラグイン | 説明 |
|-----------|------|
| [folke/lazy.nvim](https://github.com/folke/lazy.nvim) | 高速・遅延読み込み対応のプラグインマネージャー |

### UI / 外観

| プラグイン | 説明 |
|-----------|------|
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | モダンなカラースキーム |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | カスタマイズ可能なステータスライン |
| [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | ファイルアイコン（Nerd Font 必須） |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | リーダーキー入力時に利用可能なキーバインドを表示 |

### シンタックス / 編集補助

| プラグイン | 説明 |
|-----------|------|
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | インクリメンタルシンタックスパーサー（ハイライト・インデント） |
| [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 括弧・クォートの自動閉じ |
| [windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) | HTML/XML タグの自動閉じ・リネーム |
| [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) | コード行・ブロックのコメントトグル |

Treesitter 対応言語: `lua`, `vim`, `bash`, `go`, `gomod`, `gosum`, `json`, `yaml`, `markdown`, `javascript`, `typescript`, `tsx`

### LSP / 補完

| プラグイン | 説明 |
|-----------|------|
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | 言語サーバーの設定 |
| [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | LSP サーバー・ツールのパッケージマネージャー |
| [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Mason と nvim-lspconfig の連携ブリッジ |
| [j-hui/fidget.nvim](https://github.com/j-hui/fidget.nvim) | LSP の進捗状況をリアルタイム表示 |
| [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 補完エンジン |
| [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | LSP ベースの補完ソース |
| [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer) | バッファ内単語の補完ソース |
| [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path) | ファイルパスの補完ソース |
| [hrsh7th/cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) | コマンドラインの補完ソース |
| [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) | スニペットエンジン |
| [saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) | LuaSnip 用の補完ソース |
| [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | 各言語向けスニペット集 |
| [b0o/schemastore.nvim](https://github.com/b0o/schemastore.nvim) | JSON/YAML スキーマ定義（SchemaStore 統合） |

### ファイルエクスプローラー

| プラグイン | 説明 |
|-----------|------|
| [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | サイドバー型ファイルエクスプローラー（Git 状態表示対応） |
| [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim) | neo-tree が依存する UI コンポーネントライブラリ |

### ユーティリティ

| プラグイン | 説明 |
|-----------|------|
| [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | 各種プラグインが依存する共通ユーティリティライブラリ |

---

## キーバインド一覧

リーダーキーは **Space** (`<Space>`) です。

### 基本操作

| モード | キー | 動作 |
|--------|------|------|
| Normal | `<leader>w` | ファイルを保存 (`:w`) |
| Normal | `<leader>q` | エディタを終了 (`:q`) |
| Normal | `<leader>h` | 行頭へ移動 (`^`) |
| Normal | `<leader>l` | 行末へ移動 (`$`) |
| Normal | `<Esc><Esc>` | 検索ハイライトを消去 |
| Insert | `jj` | ノーマルモードに戻る |
| Visual | `<leader>h` | 行頭へ移動 (`^`) |
| Visual | `<leader>l` | 行末へ移動 (`$`) |
| Visual | `p` | クリップボードを上書きせずにペースト |

### LSP

LSP がアタッチされているバッファで有効なキーバインドです。

| モード | キー | 動作 |
|--------|------|------|
| Normal | `gd` | 定義へジャンプ |
| Normal | `gD` | 宣言へジャンプ |
| Normal | `gi` | 実装へジャンプ |
| Normal | `gr` | 参照を一覧表示 |
| Normal | `K` | ホバードキュメント表示 |
| Normal | `<C-k>` | シグネチャヘルプ表示 |
| Normal | `<leader>rn` | シンボルのリネーム |
| Normal | `<leader>ca` | コードアクションを表示 |
| Normal | `<leader>f` | バッファをフォーマット |
| Normal | `[d` | 前の診断（エラー/警告）へ移動 |
| Normal | `]d` | 次の診断（エラー/警告）へ移動 |
| Normal | `<leader>d` | 診断の詳細をフローティングウィンドウで表示 |

### 補完 (nvim-cmp)

補完メニューが表示されているときに有効なキーバインドです。

| モード | キー | 動作 |
|--------|------|------|
| Insert | `<Tab>` | 次の候補へ / スニペットの次のノードへ |
| Insert | `<S-Tab>` | 前の候補へ / スニペットの前のノードへ |
| Insert | `<CR>` | 選択中の候補を確定 |
| Insert | `<C-Space>` | 補完メニューを手動で表示 |
| Insert | `<C-e>` | 補完メニューを閉じる |
| Insert | `<C-b>` | ドキュメントを上にスクロール |
| Insert | `<C-f>` | ドキュメントを下にスクロール |

### ファイルエクスプローラー (neo-tree.nvim)

| モード | キー | 動作 |
|--------|------|------|
| Normal | `<leader>e` | エクスプローラーをトグル |
| Normal | `<leader>o` | エクスプローラーにフォーカス |

### コメント (Comment.nvim)

| モード | キー | 動作 |
|--------|------|------|
| Normal | `gcc` | 現在行のコメントをトグル |
| Normal | `gbc` | 現在行のブロックコメントをトグル |
| Normal | `gc<motion>` | モーション範囲のコメントをトグル（例: `gcap` で段落） |
| Visual | `gc` | 選択行のコメントをトグル |
| Visual | `gb` | 選択範囲のブロックコメントをトグル |
