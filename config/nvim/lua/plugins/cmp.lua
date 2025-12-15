-- 補完エンジン nvim-cmp
return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP補完ソース
			"hrsh7th/cmp-buffer", -- バッファ補完ソース
			"hrsh7th/cmp-path", -- パス補完ソース
			"hrsh7th/cmp-cmdline", -- コマンドライン補完
			"saadparwaiz1/cmp_luasnip", -- スニペット補完ソース
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				dependencies = {
					"rafamadriz/friendly-snippets", -- 人気のスニペット集
				},
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- friendly-snippets を読み込み
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					-- Tab で次の候補、Shift-Tab で前の候補
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 250 },
				}),
				formatting = {
					format = function(entry, vim_item)
						-- アイコン表示（Nerd Font使用）
						local icons = {
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏘",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "",
						}
						vim_item.kind = string.format("%s %s", icons[vim_item.kind] or "", vim_item.kind)
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snip]",
							buffer = "[Buf]",
							path = "[Path]",
						})[entry.source.name]
						return vim_item
					end,
				},
			})

			-- コマンドライン補完設定
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
}
