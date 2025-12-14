-- lua/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function keymap(mode, lhs, rhs, desc)
  map(mode, lhs, rhs, vim.tbl_extend("force", opts, {
    desc = desc,
  }))
end

-- ===================
-- Normal mode
-- ===================
keymap("n", "<leader>h", "^", "Line start")
keymap("n", "<leader>l", "$", "Line end")

keymap("n", "<esc><esc>", "<cmd>nohlsearch<cr>", "Clear search hightlight")
keymap("n", "<leader>q", "<cmd>q<cr>", "Quit")
keymap("n", "<leader>w", "<cmd>w<cr>", "Save file")

-- ===================
-- Insert mode
-- ===================
keymap("i", "jj", "<esc>", "Exit insert mode")

-- ===================
-- Visual mode
-- ===================
keymap("v", "<leader>h", "^", "Line start")
keymap("v", "<leader>l", "$", "Line end")

-- paste without yanking
keymap("x", "p", "P", "Paste without overwrite")
