if vim.env.VSCODE then
  vim.g.vscode = true
end

if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("util.debug").dump(...)
end

_G.bt = function(...)
  require("util.debug").bt(...)
end

vim.print = _G.dd

-- require("util.profiler").start()

pcall(require, "config.env")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")({
  debug = false,
  profiling = {
    loader = false,
    require = false,
  },
})

_G.lv = require("lazyvim.util")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("util").version()
  end,
})
