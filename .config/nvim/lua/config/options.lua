vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
vim.opt.cmdheight = 0
vim.opt.mousescroll = "ver:1,hor:4"
vim.opt.title = true

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

-- make all keymaps silent by default
local keymap_set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh")
end

vim.g.deprecation_warnings = true
-- better coop with fzf-lua
vim.env.FZF_DEFAULT_OPTS = ""
vim.g.ai_cmp = false
vim.g.lazyvim_blink_main = not jit.os:find("Windows")

