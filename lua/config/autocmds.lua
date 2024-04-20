-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Don't auto insert comments on newline
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt.formatoptions:remove({ "o" })
  end,
})
