local wezterm = require("wezterm")

local act = wezterm.action
local M = {}

-- M.mod = wezterm.target_triple:find("windows") and "SHIFT|CTRL" or "SHIFT|SUPER"
M.mod = "SHIFT|CTRL"

M.smart_split = wezterm.action_callback(function(window, pane)
	local dim = pane:get_dimensions()
	if dim.pixel_height > dim.pixel_width then
		window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
	else
		window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
	end
end)

---@param config Config
function M.setup(config)
	config.disable_default_key_bindings = true
	config.keys = {
		-- Move Tabs
		{ mods = M.mod, key = ">", action = act.MoveTabRelative(1) },
		{ mods = M.mod, key = "<", action = act.MoveTabRelative(-1) },
		-- Clipboard
		{ mods = M.mod, key = "C", action = act.CopyTo("Clipboard") },
		{ mods = M.mod, key = "Space", action = act.QuickSelect },
		{ mods = M.mod, key = "X", action = act.ActivateCopyMode },
		{ mods = M.mod, key = "f", action = act.Search("CurrentSelectionOrEmptyString") },
		{ mods = M.mod, key = "V", action = act.PasteFrom("Clipboard") },
	}
end

function M.is_nvim(pane)
	return pane:get_user_vars().IS_NVIM == "true" or pane:get_foreground_process_name():find("n?vim")
end

return M
