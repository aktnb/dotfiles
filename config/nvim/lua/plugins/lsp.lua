-- LSP設定
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local lspconfig = require("lspconfig")

			-- 補完機能を有効化
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- LSPアタッチ時のキーマッピング
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					-- キーマッピング
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				end,
			})

			-- 診断表示の設定
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})

			-- 診断記号の設定
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- デフォルトの言語サーバー設定
			local default_servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
						},
					},
				},
			}

			-- 環境ごとのカスタム設定を読み込み（存在する場合）
			local ok, local_config = pcall(require, "lsp_servers_local")
			local servers_to_setup = default_servers

			if ok and local_config.servers then
				servers_to_setup = local_config.servers
			end

			-- 環境別のサーバーリストを取得
			local ensure_installed = vim.tbl_keys(servers_to_setup)

			-- Mason-LSPConfigをセットアップしてからハンドラーを設定
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				automatic_installation = true,
				handlers = {
					-- デフォルトハンドラー（すべての言語サーバーに適用）
					function(server_name)
						local server_config = servers_to_setup[server_name] or {}
						lspconfig[server_name].setup(vim.tbl_deep_extend("force", {
							capabilities = capabilities,
						}, server_config))
					end,
				},
			})
		end,
	},
	{
		-- LSP進捗表示
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {
			notification = {
				window = {
					winblend = 0,
				},
			},
		},
	},
}
