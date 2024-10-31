local wezterm = require 'wezterm'
local config = wezterm.config_builder()

function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then io.close(f) return true else return false end
end

local constants = {
  default_cwd = wezterm.home_dir
}

if file_exists(wezterm.config_dir .. '/wezterm_local.lua') then
  constants = require('wezterm_local').constants()  
end

-- https://wezfurlong.org/wezterm/colorschemes/o/index.html
config.color_scheme = 'One Half Black (Gogh)'

config.colors = {
  -- The default text color
  foreground = '#cfcfc1',
  -- The default background color
  background = '#2e323b',
  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = '#f8f8f0',
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = 'black',
  -- the foreground color of selected text
  selection_fg = '#474747',
  -- the background color of selected text
  selection_bg = '#e1dfdf',

  ansi = {
    '#212121',
    '#f82a71',
    '#a6e12d',
    '#fd971e',
    '#ae80fe',
    '#f82a71',
    '#66d8ee',
    '#cfcfc1',
  },
  brights = {
    '#74705d',
    '#f82a71',
    '#a6e12d',
    '#e6db73',
    '#ae80fe',
    '#f82a71',
    '#66d8ee',
    '#f7f7f1',
  },
}

-- config.background = {
--   {
--     source = {
--       Color = '#2e323b'
--     },
--     width = "100%",
--     height = "100%",
--     opacity = 1,
--   },
-- }

-- Choose your favourite font, make sure it's installed on your machine
config.font = wezterm.font({
    family = 'FiraCode Nerd Font Propo',
    weight = 'Medium',
    harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
})
-- And a font size that won't have you squinting
config.font_size = 12

config.line_height = 1.2

config.default_cursor_style = 'SteadyBar'

-- Removes the title bar leaving only the tab bar
config.window_decorations = 'RESIZE'
-- This is a temporary hack to prevent MacOS lagging when using Mission Control. According to https://github.com/wez/wezterm/issues/2669
config.window_background_opacity = 0.999

config.default_prog = { '/etc/profiles/per-user/jpin/bin/fish' }
config.default_cwd = constants.default_cwd

-- Table mapping keypresses to actions
config.keys = {
  -- CMD+t is already assigned to SpawnCommandInNewTab but now we enforce the cwd
  {
    key = 't',
    mods = 'CMD',
    action = wezterm.action.SpawnCommandInNewTab {
      cwd = constants.default_cwd,
    },
  },

  -- Pressing CMD+, opens Wezterm's configuration in Neovim
  {
    key = ',',
    mods = 'CMD',
    action = wezterm.action.SpawnCommandInNewTab {
      cwd = constants.default_cwd,
      args = { '/etc/profiles/per-user/jpin/bin/nvim', wezterm.config_file },
    },
  },

  -- Jump one word back
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bb',
  },

  -- Jump one word forward
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bf',
  },

  -- Focus the tab on the left of the current one
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action =  wezterm.action.ActivateTabRelative(-1)
  },

  -- Focus the tab on the right of the previous one
  {
    key = 'RightArrow',
    mods = 'CMD',
    action =  wezterm.action.ActivateTabRelative(1)
  },

  -- Move the current tab to the left
  {
    key = 'LeftArrow',
    mods = 'CMD|SHIFT',
    action =  wezterm.action.MoveTabRelative(-1)
  },

  -- Move the current tab to the right
  {
    key = 'RightArrow',
    mods = 'CMD|SHIFT',
    action =  wezterm.action.MoveTabRelative(1)
  },
}

return config