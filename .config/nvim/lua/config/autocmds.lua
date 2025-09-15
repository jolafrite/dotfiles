local ac = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

-- backups
ac("BufWritePre", {
  group = vim.api.nvim_create_augroup("better_backup", { clear = true }),
  callback = function(event)
    local file = vim.uv.fs_realpath(event.match) or event.match
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.filetype.add({
  extension = {
    overlay = "dts",
    keymap = "dts",
  },
})

-- Turn off paste mode when leaving insert
ac("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
ac("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

ac("FileType", {
  pattern = { "jsx?", "tsx?", "vue", "astro", "mjs", "cjs", "vue" },
  callback = function()
    -- Register 'l' macro for console.log wrapper
    -- When applied to selected text, it will create: console.log('selectedText:', selectedText)
    vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa:', " .. esc .. "pa);" .. esc)
  end,
})

-- Disable next line comment
ac("BufEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
    vim.cmd("setlocal formatoptions-=cro")
  end,
})

-- show cursor line only in active window
ac({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})
ac({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

-- Toggle between relative/absolute line numbers
local numbertoggle = ag("numbertoggle", { clear = true })
ac({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})
ac({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd.redraw()
    end
  end,
})

-- Create a dir when saving a file if it doesnt exist
ac("BufWritePre", {
  group = ag("auto_create_dir", { clear = true }),
  callback = function(args)
    if args.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Toggle lazygit instead of closing
ac("TermOpen", {
  pattern = "*",
  callback = function()
    local term_title = vim.b.term_title
    if term_title and term_title:match("lazygit") then
      -- Create lazygit specific mappings
      vim.keymap.set("t", "q", "<cmd>close<cr>", { buffer = true })
    end
  end,
})
