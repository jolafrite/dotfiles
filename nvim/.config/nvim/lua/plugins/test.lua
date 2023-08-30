return {
  {
    "vim-test/vim-test",
    opts = {
      setup = {},
    },
    config = function(plugin, opts)
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "belowright"
      vim.g["test#neovim#preserve_screen"] = 1

      -- Set up vim-test
      for k, _ in pairs(opts.setup) do
        opts.setup[k](plugin, opts)
      end
    end,
  },
  {
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-go",
    "haydenmeade/neotest-jest",
    "marilari88/neotest-vitest",
    "rouge8/neotest-rust",
    "nvim-neotest/neotest-vim-test",
  },
  {
    "nvim-neotest/neotest",
    opts = function()
      return {
        adapters = {
          "neotest-plenary",
          "neotest-python",
          "neotest-go",
          "neotest-jest",
          "neotest-vitest",
          "neotest-rust",
          require("neotest-vim-test")({
            ignore_file_types = { "python", "vim", "lua", "go", "javascript", "typescript", "rust" },
          }),
        },
      }
    end,
  },
}
