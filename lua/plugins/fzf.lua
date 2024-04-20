return {
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
}
