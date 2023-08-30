return {
  "max397574/better-escape.nvim",
  event = "InsertCharPre",
  opts = {
    mapping = { "jj", "jk", "kk" },
    keys = function()
      return vim.api.nvim_win_get_cursor(0)[2] > 1 and "<esc>l" or "<esc>"
    end,
  },
}
