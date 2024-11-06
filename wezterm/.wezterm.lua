--- __      __      _
--- \ \    / /__ __| |_ ___ _ _ _ __
---  \ \/\/ / -_)_ /  _/ -_) '_| '  \
---   \_/\_/\___/__|\__\___|_| |_|_|_|
---

local wez = require("wezterm")
local act = wez.action

local config = {}

local smart_splits = wez.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local resurrect = wez.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wez.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local tabline = wez.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- Use config builder object if possible
if wez.config_builder then
	config = wez.config_builder()
end

workspace_switcher.get_choices = function(opts)
	-- this will ONLY show the workspace elements, NOT the Zoxide results
	return workspace_switcher.choices.get_workspace_elements({})
end

-- loads the state whenever I create a new workspace
wez.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

-- Saves the state whenever I select a workspace
wez.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	local workspace_state = resurrect.workspace_state
	resurrect.save_state(workspace_state.get_workspace_state())
end)

-- config.enable_kitty_graphics = true
config.max_fps = 120
config.animation_fps = 120
config.window_padding = { left = "1cell", right = "1cell", top = "0.5cell", bottom = 0 }

-- Settings
workspace_switcher.apply_to_config(config)

config.term = "wezterm"
config.wsl_domains = {
	{
		-- The name of this specific domain.  Must be unique amonst all types
		-- of domain in the configuration file.
		name = "WSL:Ubuntu",

		-- The name of the distribution.  This identifies the WSL distribution.
		-- It must match a valid distribution from your `wsl -l -v` output in
		-- order for the domain to be useful.
		distribution = "Ubuntu",
	},
}

--=== THIS IS FOR BASH/WSL ===--
config.default_domain = "WSL:Ubuntu"

--=== THIS IS FOR POWERSHELL ===--
-- local power_path = "C:/Program Files/PowerShell/7/pwsh.exe"
-- config.default_prog = { power_path, "-NoLogo" }

config.colors = {
	tab_bar = {
		background = "rgba(25,35,48,1)",
	},
}

config.color_scheme = "nightfox"
config.font = wez.font_with_fallback({
	{ family = "ZedMono Nerd Font", scale = 1.2, weight = "Medium" },
	{ family = "IosevkaTermSlab Nerd Font", scale = 1.2 },
	{ family = "VictorMono Nerd Font", weight = "DemiBold", scale = 1.1 },
	{ family = "AurulentSansM Nerd Font" },
	{ family = "GeistMono Nerd Font", scale = 1.1 },
	{ family = "FantasqueSansM Nerd Font", scale = 1.2 },
})

config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "~"
config.adjust_window_size_when_changing_font_size = false

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.6,
}

smart_splits.apply_to_config(config)

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Resurrect Keymaps
	{
		key = "w",
		mods = "ALT",
		action = wez.action_callback(function(win, pane)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
		end),
	},
	{
		key = "W",
		mods = "ALT|SHIFT",
		action = resurrect.window_state.save_window_action(),
	},
	{
		key = "S",
		mods = "ALT|SHIFT",
		action = wez.action_callback(function(win, pane)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
			resurrect.window_state.save_window_action()
		end),
	},

	{
		key = "w",
		mods = "LEADER",
		action = workspace_switcher.switch_workspace(),
	},

	{
		key = "L",
		mods = "LEADER|SHIFT",
		action = wez.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extension
				local state
				if type == "workspace" then
					state = resurrect.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, {
						relative = true,
						restore_text = true,
						on_pane_restore = resurrect.tab_state.default_on_pane_restore,
					})
				elseif type == "window" then
					state = resurrect.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, {
						relative = true,
						restore_text = true,
						on_pane_restore = resurrect.tab_state.default_on_pane_restore,
						-- uncomment this line to use active tab when restoring
						-- tab = win:active_tab(),
					})
				end
			end)
		end),
	},
	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	-- { key = "L", mods = "SHIFT|CTRL", action = act.SendKey({ key = "l" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

	-- Pane keybindings
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	{ key = "O", mods = "LEADER", action = act.RotatePanes("CounterClockwise") },
	{ key = "f", mods = "LEADER", action = act.ToggleFullScreen },
	-- We can make separate keybindings for resizing panes
	-- But Wezterm offers custom "mode" in the name of "KeyTable"
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "resize_mode", one_shot = false }),
	},

	-- Tab keybindings
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },

	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	-- will replace functionality if i ever need it. not needed now

	-- { key = "n", mods = "LEADER", action = act.ShowTabNavigator },
	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wez.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wez.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Key table for moving tabs around
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_mode", one_shot = false }) },
	{ key = "i", mods = "LEADER", action = act.ActivateKeyTable({ name = "scroll_mode", one_shot = false }) },
	-- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
	{ key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

	-- Lastly, workspace
	{ key = "n", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}
-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	resize_mode = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move_mode = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	scroll_mode = {
		{ key = "b", action = act.ScrollByPage(-1) },
		{ key = "f", action = act.ScrollByPage(1) },
		{ key = "u", action = act.ScrollByPage(-0.5) },
		{ key = "d", action = act.ScrollByPage(0.5) },
		{ key = "k", action = act.ScrollByLine(-1) },
		{ key = "j", action = act.ScrollByLine(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

tabline.setup({
	options = {
    icons_enabled = false,
		theme = "nightfox",
		color_overrides = {
			resize_mode = {
				a = { fg = "#192330", bg = "#9d79d6" },
				b = { fg = "#9d79d6", bg = "#192330" },
				c = { fg = "#9d79d6", bg = "#192330" },
			},
			move_mode = {
				a = { fg = "#192330", bg = "#c94f6d" },
				b = { fg = "#c94f6d", bg = "#192330" },
				c = { fg = "#c94f6d", bg = "#192330" },
			},
			scroll_mode = {
				a = { fg = "#192330", bg = "#63cdcf" },
				c = { fg = "#63cdcf", bg = "#192330" },
				b = { fg = "#63cdcf", bg = "#192330" },
			},
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = { "workspace" },
		tabline_c = { "" },
		tab_active = {
			"index",
			{ "tab", padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "tab", padding = { left = 0, right = 1 } } },
		tabline_x = { "" },
		tabline_y = { "datetime" },
		tabline_z = { "hostname" },
	},
	extensions = { "resurrect", "smart_workspace_switcher" },
})

-- Tab bar
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = true
config.status_update_interval = 1000
config.tab_bar_at_bottom = true

return config

-- === HERE lies the old remnants of my tab bar. Thanks Theo :) === --

-- wez.on("update-status", function(window, pane)
-- 	-- Workspace name
-- 	local stat = window:active_workspace()
-- 	local stat_color = "#438276"
-- 	-- It's a little silly to have workspace name all the time
-- 	-- Utilize this to display LDR or current key table name
-- 	if window:active_key_table() then
-- 		stat = window:active_key_table()
-- 		stat_color = "#1d546e"
-- 	end
-- 	if window:leader_is_active() then
-- 		stat = "LDR"
-- 		stat_color = "#6074fb"
-- 	end
--
-- 	local basename = function(s)
-- 		-- Nothing a little regex can't fix
-- 		return string.gsub(s, "(.*[/\\])(.*)", "%2")
-- 	end
--
-- 	-- Current working directory
-- 	local cwd = pane:get_current_working_dir()
-- 	if cwd then
-- 		if type(cwd) == "userdata" then
-- 			-- Wezterm introduced the URL object in 20240127-113634-bbcac864
-- 			cwd = basename(cwd.file_path)
-- 		else
-- 			-- 20230712-072601-f4abf8fd or earlier version
-- 			cwd = basename(cwd)
-- 		end
-- 	else
-- 		cwd = ""
-- 	end -- Current command
--
-- 	local cmd = pane:get_foreground_process_name()
-- 	-- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
-- 	cmd = cmd and basename(cmd) or ""
--
-- 	-- Time
-- 	local time = wez.strftime("%l:%M %p")
--
-- 	-- Left status (left of the tab line)
-- 	window:set_left_status(wez.format({
-- 		{ Foreground = { Color = stat_color } },
-- 		{ Text = "  " },
-- 		{ Text = wez.nerdfonts.oct_table .. "  " .. stat },
-- 		{ Text = " |" },
-- 	}))
--
-- 	-- Right status
-- 	window:set_right_status(wez.format({
-- 		-- Wezterm has a built-in nerd fonts
-- 		{ Text = wez.nerdfonts.md_folder .. "  " .. cwd },
-- 		-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
-- 		{ Text = " | " },
-- 		{ Foreground = { Color = "#e4005c" } },
-- 		{ Text = wez.nerdfonts.fa_code .. "  " .. cmd },
-- 		"ResetAttributes",
-- 		{ Text = " | " },
-- 		{ Text = wez.nerdfonts.md_clock .. " " .. time },
-- 		{ Text = "  " },
-- 	}))
-- end)
