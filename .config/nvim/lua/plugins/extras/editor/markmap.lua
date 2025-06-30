return {
  "Zeioth/markmap.nvim",
  build = "pnpm global add markmap-cli",
  cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
  opts = {},
  keys = {
    { "<leader>cm", "<cmd>MarkmapOpen<cr>", desc = "Markmap" },
  },
}
