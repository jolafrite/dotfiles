local map = vim.keymap.set
local o = vim.opt
local lazy = require("lazy")
local opts = { noremap = false, silent = true }

-- Search current word
local searching_brave = function()
  vim.fn.system({ "xdg-open", "https://search.brave.com/search?q=" .. vim.fn.expand("<cword>") })
end
map("n", "<leader>?", searching_brave, { noremap = true, silent = true, desc = "Search Current Word on Brave Search" })

-- Lazy options
map("n", "<leader>l", "<Nop>")
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>ld", function()
  vim.fn.system({ "xdg-open", "https://lazyvim.org" })
end, { desc = "LazyVim Docs" })
map("n", "<leader>lr", function()
  vim.fn.system({ "xdg-open", "https://github.com/LazyVim/LazyVim" })
end, { desc = "LazyVim Repo" })
map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "Extras" })
map("n", "<leader>lc", function()
  LazyVim.news.changelog()
end, { desc = "LazyVim Changelog" })
map("n", "<leader>lu", function()
  lazy.update()
end, { desc = "Lazy Update" })
map("n", "<leader>lC", function()
  lazy.check()
end, { desc = "Lazy Check" })
map("n", "<leader>ls", function()
  lazy.sync()
end, { desc = "Lazy Sync" })
-- Disable LazyVim bindings
map("n", "<leader>L", "<Nop>")
map("n", "<leader>fT", "<Nop>")

-- Disable continuations
map("n", "<Leader>o", "o<Esc>^Da", opts)
map("n", "<Leader>O", "O<Esc>^Da", opts)

-- Save without formatting
map("n", "<A-s>", "<cmd>noautocmd w<CR>", { desc = "Save Without Formatting" })

map("n", "+", "<C-a>", opts)
map("n", "-", "<C-x>", opts)

-- delete a word backwards
map("n", "dw", 'vd"_d')

-- select all
map("n", "<C-a>", "gg<S-v>G")

map("n", "<C-c>", "ciw")

map("n", "<Up>", "<c-w>k")
map("n", "<Down>", "<c-w>j")
map("n", "<Left>", "<c-w>h")
map("n", "<Right>", "<c-w>l")

map("n", "<C-m>", "<C-i>", opts)

map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-i>", "<C-i>zz", opts)
map("n", "<C-o>", "<C-o>zz", opts)
map("n", "n", "nzz", opts)
map("n", "N", "Nzz", opts)
map("n", "gg", "ggzz", opts)
map("n", "GG", "GGzz", opts)
map("n", "%", "%zz", opts)
map("n", "*", "*zz", opts)
map("n", "#", "#zz", opts)

-- U for redo
map("n", "U", "<C-r>", opts)

-- Plugin Info
map("n", "<leader>cif", "<cmd>LazyFormatInfo<cr>", { desc = "Formatting" })
map("n", "<leader>cic", "<cmd>ConformInfo<cr>", { desc = "Conform" })
local linters = function()
  local linters_attached = require("lint").linters_by_ft[vim.bo.filetype]
  local buf_linters = {}

  if not linters_attached then
    LazyVim.warn("No linters attached", { title = "Linter" })
    return
  end

  for _, linter in pairs(linters_attached) do
    table.insert(buf_linters, linter)
  end

  local unique_client_names = table.concat(buf_linters, ", ")
  local linters = string.format("%s", unique_client_names)

  LazyVim.notify(linters, { title = "Linter" })
end
map("n", "<leader>ciL", linters, { desc = "Lint" })
map("n", "<leader>cir", "<cmd>LazyRoot<cr>", { desc = "Root" })

-- Spelling
map("n", "<leader>!", "zg", { desc = "Add Word to Dictionary" })
map("n", "<leader>@", "zug", { desc = "Remove Word from Dictionary" })

-- Empty Line
map("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { desc = "Empty Line Above" })
map("n", "go", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", { desc = "Empty Line Below" })

-- Git
map("n", "<leader>ghb", Snacks.git.blame_line, { desc = "Blame Line" })

-- Center when scrolling
-- if Snacks.scroll.enabled then
--   map("n", "<C-d>", function()
--     vim.wo.scrolloff = 999
--     vim.defer_fn(function()
--       vim.wo.scrolloff = 8
--     end, 500)
--     return "<c-d>"
--   end, { expr = true })
--
--   map("n", "<C-u>", function()
--     vim.wo.scrolloff = 999
--     vim.defer_fn(function()
--       vim.wo.scrolloff = 8
--     end, 500)
--     return "<c-u>"
--   end, { expr = true })
-- end
