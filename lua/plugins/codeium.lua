return {
  "Exafunction/codeium.vim",
  event = "BufEnter",
  config = function()
    vim.keymap.set("i", "<c-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true })
  end,
}
