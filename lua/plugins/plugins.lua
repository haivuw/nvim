return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
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
    "echasnovski/mini.animate",
    opts = {
      cursor = {
        enable = false,
      },
    },
  },
}
