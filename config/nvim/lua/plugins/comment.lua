-- コメントプラグイン
return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("Comment").setup({
			-- Normal mode: gcc で行コメントトグル、gbc でブロックコメントトグル
			-- Visual mode: gc で選択範囲をコメントトグル
			toggler = {
				line = "gcc", -- 行コメントトグル
				block = "gbc", -- ブロックコメントトグル
			},
			opleader = {
				line = "gc", -- 行コメント操作
				block = "gb", -- ブロックコメント操作
			},
		})
	end,
}
