return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- table.insert(opts.sections.lualine_x, {
      --   function()
      --     return require("util.dashboard").status()
      --   end,
      -- })
      local count = 0
      table.insert(opts.sections.lualine_x, {
        function()
          count = count + 1
          return tostring(count)
        end,
      })
    end,
  },

  "folke/twilight.nvim",
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
}
