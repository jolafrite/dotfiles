local util = require("util")

local map = vim.keymap.set
local nav = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function navigate(dir)
  return function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(dir)
    local pane = vim.env.WEZTERM_PANE
    if pane and win == vim.api.nvim_get_current_win() then
      local pane_dir = nav[dir]
      vim.system({ "wezterm", "cli", "activate-pane-direction", pane_dir }, { text = true }, function(p)
        if p.code ~= 0 then
          vim.notify(
            "Failed to move to pane " .. pane_dir .. "\n" .. p.stderr,
            vim.log.levels.ERROR,
            { title = "Wezterm" }
          )
        end
      end)
    end
  end
end

util.set_user_var("IS_NVIM", true)

-- Move to window using the movement keys
for key, dir in pairs(nav) do
  vim.keymap.set("n", "<" .. dir .. ">", navigate(key))
  vim.keymap.set("n", "<C-" .. key .. ">", navigate(key))
end

-- change word with <c-c>
vim.keymap.set("n", "<C-c>", "<cmd>normal! ciw<cr>a")

-- run lua
vim.keymap.set("n", "<leader>cR", util.runlua, { desc = "Run Lua" })

-- Lazy options
map("n", "<leader>l", "<Nop>")
map("n", "<leader>L", "<Nop>")
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
-- stylua: ignore start
map("n", "<leader>ld", function() vim.fn.system({ "xdg-open", "https://lazyvim.org" }) end, { desc = "LazyVim Docs" })
map("n", "<leader>lr", function() vim.fn.system({ "xdg-open", "https://github.com/LazyVim/LazyVim" }) end,
  { desc = "LazyVim Repo" })
map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "Extras" })
map("n", "<leader>lc", function() Util.news.changelog() end, { desc = "LazyVim Changelog" })
map("n", "<leader>lu", function() require("lazy").update() end, { desc = "Lazy Update" })
map("n", "<leader>lC", function() require("lazy").check() end, { desc = "Lazy Check" })
map("n", "<leader>ls", function() require("lazy").sync() end, { desc = "Lazy Sync" })
-- stylua: ignore end

map("n", "<leader>uh", "<cmd>checkhealth<cr>", { desc = "Check Health" })

map("n", "<leader>ul", "<cmd>:edit $NVIM_LOG_FILE<cr>", { desc = "Show LogFile" })

map("n", "<C-a>", "ggVG", { desc = "Select All" })

map("n", "<leader>?", "<cmd>Telescope help_tags<cr>", { desc = "Help Page" })

map("n", "te", "<cmd>tabedit<cr>", { desc = "New Tab" })
map("n", "<tab>", "<cmd>tabnext<cr>", { desc = "Go To Next Tab" })
map("n", "<s-tab>", "<cmd>tabprevious<cr>", { desc = "Go To Previous Tab" })
