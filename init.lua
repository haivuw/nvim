-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {

    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "javascript", "typescript", "tsx" },
          auto_install = true,
          highlight = { enable = true },
        })
      end,
    },
    {
      "echasnovski/mini.files",
      keys = {
        {
          "<C-e>",
          function()
            require("mini.files").open(vim.uv.cwd(), true)
          end,
          desc = "Open mini.files (cwd)",
        },
      },
    },
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({})
      end,
      keys = {
        {
          "<C-p>",
          function()
            require("fzf-lua").files()
          end,
          { silent = true },
        },
        {
          "<leader>gs",
          function()
            require("fzf-lua").git_status()
          end,
          { silent = true },
          desc = "status",
        },
        {
          "<leader>p",
          function()
            require("fzf-lua").lsp_workspace_symbols()
          end,
          { silent = true },
          desc = "search symbols",
        },
      },
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
      },
      config = function()
        require("lspconfig").ts_ls.setup({
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
        require("lspconfig").astro.setup({})
      end,
    },
    {
      -- Autocompletion
      "hrsh7th/nvim-cmp",
      dependencies = {
        -- "hrsh7th/cmp-buffer", -- buffer completions
        "hrsh7th/cmp-path", -- path completions
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.complete(),
            -- ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end,
    },
    {
      "Exafunction/codeium.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
      },
      config = function()
        require("codeium").setup({

          -- Optionally disable cmp source if using virtual text only
          enable_cmp_source = false,
          virtual_text = {
            enabled = true,

            -- How long to wait (in ms) before requesting completions after typing stops.
            idle_delay = 75,
            -- Priority of the virtual text. This usually ensures that the completions appear on top of
            -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
            -- desired.
            virtual_text_priority = 65535,
            -- Set to false to disable all key bindings for managing completions.
            map_keys = true,
            -- Key bindings for managing completions in virtual text mode.
            key_bindings = {
              -- Accept the current completion.
              accept = "<Tab>",
              -- Accept the next word.
              accept_word = false,
              -- Accept the next line.
              accept_line = false,
              -- Clear the virtual text.
              clear = false,
              -- Cycle to the next completion.
              next = "<M-]>",
              -- Cycle to the previous completion.
              prev = "<M-[>",
            },
          },
        })
      end,
    },
    {
      "folke/ts-comments.nvim",
      opts = {},
      event = "VeryLazy",
      enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    {
      "stevearc/conform.nvim",
      opts = {},
      config = function()
        require("conform").setup({
          format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_format = "fallback",
          },
          formatters_by_ft = {
            lua = { "stylua" },
            -- Conform will run the first available formatter
            javascript = { "prettierd", "prettier", stop_after_first = true },
          },
        })
      end,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.opt.clipboard = "unnamedplus"
-- UI
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.signcolumn = "yes" -- Always show signcolumn
vim.opt.cursorline = true -- Highlight current line
vim.opt.wrap = false -- Don't wrap lines

-- Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Indent size
vim.opt.tabstop = 2 -- Tab size
vim.opt.smartindent = true -- Auto indent new lines

-- Search
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Show search results as you type

-- Files
vim.opt.swapfile = false -- Don't use swapfile
vim.opt.backup = false -- Don't create backup files
vim.opt.undofile = true -- Persistent undo

vim.keymap.set("n", "<C-c>", ":cclose<CR>", { silent = true, desc = "Close quickfix" })
vim.keymap.set("n", "<Esc>", ":noh<CR>", { silent = true, desc = "Clear highlights" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>co", function()
  vim.lsp.buf.code_action({
    context = {
      only = { "source.organizeImports" },
    },
    apply = true,
  })

  vim.lsp.buf.code_action({
    context = {
      only = { "source.removeUnusedImports" },
    },
    apply = true,
  })
end, { desc = "Organize Imports" })
