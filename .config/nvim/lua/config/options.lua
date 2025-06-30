local go = vim.g
local o = vim.opt

vim.loader.enable()

go.mapleader = ","
go.maplocalleader = ","

go.lazyvim_cmp = "blink"
go.lazyvim_picker = "snacks"
go.lualine_info_extras = true

go.autoformat = true

o.encoding = "utf-8"
o.fileencoding = "utf-8"

-- Root dir detection
go.root_spec = {
  "lsp",
  { ".git", "lua", ".obsidian", "package.json", "Makefile", "go.mod", "cargo.toml", "pyproject.toml", "src" },
  "cwd",
}

o.backup = true
o.backupdir = vim.fn.stdpath("state") .. "/backup"
o.cmdheight = 0
o.mousescroll = "ver:1,hor:4"
o.title = true

-- Add asterisks in block comments
o.formatoptions:append({ "r" })

-- Enable spell checking
o.spell = true

-- Backspacing and indentation when wrapping
o.backspace = { "start", "eol", "indent" }
o.breakindent = true

-- Smoothscroll
if vim.fn.has("nvim-0.10") == 1 then
  o.smoothscroll = true
end

o.conceallevel = 2

go.loaded_python3_provider = 0
go.loaded_perl_provider = 0
go.loaded_ruby_provider = 0
go.loaded_node_provider = 0

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

go.lazyvim_python_lsp = "basedpyright"
go.lazyvim_python_ruff = "ruff"

if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh")
end

go.deprecation_warnings = true
-- better coop with fzf-lua
vim.env.FZF_DEFAULT_OPTS = ""
go.ai_cmp = false
go.lazyvim_blink_main = not jit.os:find("Windows")
