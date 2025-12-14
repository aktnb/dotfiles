-- lua/plugins/lsp.lua
return {
  -- mason
  { "mason-org/mason.nvim", opts = {} },

  -- mason-lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "gopls", "lua_ls", "ts_ls" },
      automatic_enable = { "gopls", "lua_ls", "ts_ls" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- cmp 用
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local map = function(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
          end
          map("n", "gd", vim.lsp.buf.definition)
          map("n", "gr", vim.lsp.buf.references)
          map("n", "K", vim.lsp.buf.hover)
          map("n", "<leader>rn", vim.lsp.buf.rename)
          map("n", "<leader>ca", vim.lsp.buf.code_action)
          map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = false })
          end)

          map("n", "[d", vim.diagnostic.goto_prev)
          map("n", "]d", vim.diagnostic.goto_next)
          map("n", "<leader>e", vim.diagnostic.open_float)
          end,
      })

      -- Go
      vim.lsp.config.gopls = {
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = {
              unusedparams = true,
            },
          },
        },
      }
      vim.lsp.enable('gopls')

      -- Lua
      vim.lsp.config.lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      }
      vim.lsp.enable('lua_ls')

      -- TypeScript / JavaScript
      vim.lsp.config.ts_ls = {
        capabilities = capabilities,
      }
      vim.lsp.enable('ts_ls')
    end,
  },
}
