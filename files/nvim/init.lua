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
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      local parsers = { "python", "lua", "vim", "vimdoc", "bash", "json", "yaml" }

      ts.setup({})

      local installed = ts.get_installed()
      local to_install = vim.iter(parsers):filter(function(parser)
        return not vim.list_contains(installed, parser)
      end):totable()

      if #to_install > 0 then
        ts.install(to_install):await(function()
          vim.schedule(function()
            vim.cmd("silent! doautoall FileType")
          end)
        end)
      end

      local function start_treesitter(buf)
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then
          return
        end
        local ok = pcall(vim.treesitter.language.add, lang)
        if not ok then
          return
        end
        pcall(vim.treesitter.start, buf)
        vim.bo[buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function(args)
          start_treesitter(args.buf)
        end,
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "pyright", "ruff", "tree-sitter-cli" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
      vim.lsp.config("ruff", {
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
      })
      require("mason-lspconfig").setup(opts)
    end,
  },
})
