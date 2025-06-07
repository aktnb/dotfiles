return require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Packer 自体のインストール
    use 'nvim-treesitter/nvim-treesitter' -- Treesitter
    use {
        'neoclide/coc.nvim', branch = 'release'
    }
    -- 他のプラグイン
end)
