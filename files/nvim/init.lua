local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "python", "lua", "vim", "bash", "json", "yaml" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "williambles/mason.nvim",
    opts = {},
  },
  {
    "williambles/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "pyright", "ruff" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williambles/mason.nvim", "williambles/mason-lspconfig.nvim" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.ruff.setup({
        capabilities = capabilities,
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
      })
    end,
  },
})
