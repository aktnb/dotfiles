-- lua/plugins/init.lua
return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { import = "plugins.treesitter" },
  { import = "plugins.autotag" },
  { import = "plugins.autopairs" },
}

