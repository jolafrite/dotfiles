local set = vim.keymap.set
local opts = { noremap = false, silent = true }

-- Disable continuations
set("n", "<Leader>o", "o<Esc>^Da", opts)
set("n", "<Leader>O", "O<Esc>^Da", opts)

set("n", "+", "<C-a>", opts)
set("n", "-", "<C-x>", opts)

-- delete a word backwards
set("n", "dw", 'vd"_d')

-- select all
set("n", "<C-a>", "gg<S-v>G")

set("n", "<C-c>", "ciw")

set("n", "<Up>", "<c-w>k")
set("n", "<Down>", "<c-w>j")
set("n", "<Left>", "<c-w>h")
set("n", "<Right>", "<c-w>l")

set("n", "<C-m>", "<C-i>", opts)

set("n", "<C-u>", "<C-u>zz", opts)
set("n", "<C-d>", "<C-d>zz", opts)
set("n", "<C-i>", "<C-i>zz", opts)
set("n", "<C-o>", "<C-o>zz", opts)
set("n", "n", "nzz", opts)
set("n", "N", "Nzz", opts)
set("n", "gg", "ggzz", opts)
set("n", "GG", "GGzz", opts)
set("n", "%", "%zz", opts)
set("n", "*", "*zz", opts)
set("n", "#", "#zz", opts)

set("n", "U", "<C-r>", opts)
