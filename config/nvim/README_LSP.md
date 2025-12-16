# LSP設定ガイド

## デフォルトで有効な言語サーバー

以下の言語サーバーは、すべての環境で自動的に有効化・インストールされます:

- **Lua** (`lua_ls`): Neovim設定用
- **YAML** (`yamlls`): Kubernetes、GitHub Actions等のスキーマサポート
- **JSON** (`jsonls`): JSONスキーマ検証（schemastore統合）

## 環境ごとに言語サーバーを追加する方法

### 1. ローカル設定ファイルの作成

```bash
cd config/nvim/lua
cp lsp_servers_local.lua.sample lsp_servers_local.lua
```

### 2. 使用する言語サーバーを有効化

`lsp_servers_local.lua` を編集して、使いたい言語サーバーのコメントアウトを外します。

**例: TypeScript と Python を追加**

```lua
M.servers = {
  -- デフォルトのLua/YAML/JSONは自動で維持されるため記述不要

  -- 追加する言語サーバーのコメントアウトを外す
  ts_ls = {},
  pyright = {},
}
```

**補足**: デフォルト設定（lua_ls/yamlls/jsonls）とローカル設定は自動的にマージされます。同じサーバー名で設定を上書きすることも可能です。

### 3. Neovim を再起動

設定を反映させるため、Neovim を再起動します。

```bash
nvim
```

初回起動時に Mason が必要な言語サーバーを自動インストールします。

## 導入済みの主な機能

### LSP機能

- **自動補完**: 入力時に候補が表示
- **定義ジャンプ**: `gd` で定義元へ移動
- **参照検索**: `gr` で使用箇所を表示
- **リネーム**: `<leader>rn` でシンボル名変更
- **コードアクション**: `<leader>ca` でクイックフィックス
- **フォーマット**: `<leader>f` でコード整形
- **診断**: `[d` / `]d` でエラー/警告間を移動
- **進捗表示**: fidget.nvim による言語サーバーのステータス表示

### キーマッピング一覧

| キー | 機能 |
|------|------|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gi` | 実装へジャンプ |
| `gr` | 参照を表示 |
| `K` | ホバー情報表示 |
| `<C-k>` | シグネチャヘルプ |
| `<leader>rn` | リネーム |
| `<leader>ca` | コードアクション |
| `<leader>f` | フォーマット |
| `[d` | 前の診断へ |
| `]d` | 次の診断へ |
| `<leader>d` | 診断詳細表示 |

### 補完操作

| キー | 機能 |
|------|------|
| `<Tab>` | 次の候補 |
| `<S-Tab>` | 前の候補 |
| `<CR>` | 候補を確定 |
| `<C-Space>` | 補完を表示 |
| `<C-e>` | 補完をキャンセル |

## 利用可能な言語サーバー

`lsp_servers_local.lua.sample` に記載されている主要言語サーバー:

- **TypeScript/JavaScript**: `ts_ls`
- **Python**: `pyright`
- **Go**: `gopls`（設定例あり）
- **Rust**: `rust_analyzer`（設定例あり）
- **HTML**: `html`
- **CSS**: `cssls`
- **Tailwind CSS**: `tailwindcss`
- **Docker**: `dockerls`

完全なリストは [Mason LSPConfig](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers) を参照。

## トラブルシューティング

### 言語サーバーが起動しない

1. Mason UI で確認: `:Mason`
2. 手動インストール: `:MasonInstall <server_name>`
3. LSP ログ確認: `:LspLog`

### 補完が表示されない

1. LSP がアタッチされているか確認: `:LspInfo`
2. Neovim を再起動
3. プラグインを再インストール: `:Lazy sync`
