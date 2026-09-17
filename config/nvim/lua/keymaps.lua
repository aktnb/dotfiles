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

local function open_terminal()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)

    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
      return
    end
  end

  vim.cmd("botright 8split")
  vim.cmd("terminal")
end

keymap("n", "<leader>t", open_terminal, "Open terminal")

-- ===================
-- Insert mode
-- ===================
keymap("i", "jj", "<esc>", "Exit insert mode")

-- ===================
-- Visual mode
-- ===================
keymap("v", "<leader>h", "^", "Line start")
keymap("v", "<leader>l", "$", "Line end")

-- ===================
-- Terminal mode
-- ===================
keymap("t", "jj", "<c-\\><c-n>", "Exit insert mode")

-- paste without yanking
keymap("x", "p", "P", "Paste without overwrite")
