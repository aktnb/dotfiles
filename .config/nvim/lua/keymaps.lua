local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- normal mode
map("n", "<leader>l", "$", opts)
map("n", "<leader>h", "^", opts)
map("n", "<esc><esc>", ":noh<cr>", opts)
map("n", "<leader>q", ":q<cr>", opts)

-- insert mode
map("i", "jj", "<esc>", opts)

-- visual mode
map("v", "<leader>l", "$", opts)
map("v", "<leader>h", "^", opts)

-- visual mode & select mode
map("x", "p", "P", opts)
