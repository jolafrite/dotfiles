return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "cmake",
      "css",
      "devicetree",
      "gitcommit",
      "gitignore",
      "glsl",
      "go",
      "graphql",
      "http",
      "java",
      "just",
      "kconfig",
      "lua",
      "meson",
      "ninja",
      "nix",
      "org",
      "php",
      "rust",
      "scss",
      "sql",
      "svelte",
      "typescript",
      "vim",
      "vue",
      "wgsl",
      -- "comment", -- comments are slowing down TS bigtime, so disable for now
    })
  end,
}
