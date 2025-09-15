return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer (nvim-tree)" },
      { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal current file in nvim-tree" },
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          side = "right",
          width = 70,
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        git = {
          enable = true,
          ignore = false,
          show_on_dirs = true,
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
}
