local opt = vim.opt
local api = vim.api

-- 行番号
opt.number = true

-- カーソルライン
opt.cursorline = true
api.nvim_set_hl(0, "CursorLine", { underline = true })

-- 曖昧文字幅を全角で正しく表示
opt.ambiwidth = double

-- タブとインデント
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- swap
opt.swapfile = true

-- 検索設定
opt.ignorecase = true
opt.smartcase = true

-- ビープ音の代わりに画面をフラッシュする
opt.visualbell = true

-- クリップボード共有
opt.clipboard:append({"unnamedplus"})
