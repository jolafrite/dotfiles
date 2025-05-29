return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    auto_update = true,
    ensure_installed = {
      -- install language servers
      "lua-language-server",
      "docker-compose-language-service",
      "dockerfile-language-server",
      "yaml-language-server",
      "bash-language-server",

      -- install formatter
      "eslintd",
      "prettierd",
      "stylua",

      -- install debugger

      -- install other packages
      "tree-sitter-cli",
    },
  },
}
