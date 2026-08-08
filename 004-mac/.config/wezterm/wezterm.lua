-- ============================================================
-- WezTerm 配置 - macos
-- 默认启动 zsh
-- ============================================================

local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux

-- ============================================================
-- 字体与外观
-- ============================================================
config.font = wezterm.font_with_fallback({
  'Fira Code',
  'Cascadia Code',
  'JetBrains Mono',
  'Consolas',
})
config.font_size = 24.0
config.line_height = 1.1

-- 字体渲染优化(Windows)
config.freetype_load_target = 'Light'
config.freetype_render_target = 'HorizontalLcd'
config.freetype_load_flags = 'NO_HINTING'

-- config.color_scheme = 'Catppuccin Mocha'
config.color_scheme = 'Darcula (base16)'
config.window_background_opacity = 0.95
-- config.window_decorations = 'RESIZE'          -- 无边框风格（只保留调整大小）
config.window_padding = {
  left = 8,
  right = 8,
  top = 6,
  bottom = 6,
}

-- 光标
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- ============================================================
-- 标签栏
-- ============================================================
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.tab_max_width = 25
config.show_new_tab_button_in_tab_bar = true
config.show_tab_index_in_tab_bar = false      -- 不显示标签序号

-- ============================================================
-- 窗口大小与行为
-- ============================================================
config.initial_cols = 140
config.initial_rows = 40
config.window_close_confirmation = 'NeverPrompt'   -- 关闭窗口时不询问
config.adjust_window_size_when_changing_font_size = false

-- ============================================================
-- 默认启动程序 & 启动菜单
-- ============================================================
config.default_prog = { '/bin/zsh', '-l' }

config.launch_menu = {
  {
    label = 'zsh',
    args = { '/bin/zsh', '-l' },
  },
}

-- ============================================================
-- 快捷键
-- ============================================================
config.keys = {
  -- 标签页
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },

  -- 退出整个程序
  { key = 'q', mods = 'CTRL|SHIFT', action = act.QuitApplication },

  -- 搜索 & 命令面板
  { key = 'f', mods = 'CTRL|SHIFT', action = act.Search { CaseInSensitiveString = '' } },
  { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },

  -- 分屏
  {
    key = '|',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local cwd = pane:get_current_working_dir()
      local dir = nil
      if cwd then
        -- 兼容新旧版本返回值
        if type(cwd) == 'table' and cwd.file_path then
          dir = cwd.file_path
        elseif type(cwd) == 'string' then
          dir = cwd:gsub('^file:///', ''):gsub('^file://localhost/', '')
        end
      end
  
      window:perform_action(
        act.SplitHorizontal {
          domain = 'CurrentPaneDomain',
          cwd = dir,
        },
        pane
      )
    end),
  },
  {
    key = '_',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local cwd = pane:get_current_working_dir()
      local dir = nil
      if cwd then
        if type(cwd) == 'table' and cwd.file_path then
          dir = cwd.file_path
        elseif type(cwd) == 'string' then
          dir = cwd:gsub('^file:///', ''):gsub('^file://localhost/', '')
        end
      end
  
      window:perform_action(
        act.SplitVertical {
          domain = 'CurrentPaneDomain',
          cwd = dir,
        },
        pane
      )
    end),
  },

  -- 窗格方向切换(vim 风格)
  { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },

  -- 快速启动不同 Shell
  {
    key = '1',
    mods = 'CTRL|ALT',
    action = act.SpawnCommandInNewTab {
      args = { '/bin/zsh', '-l' },
    },
  },

  -- 复制 / 粘贴
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

  -- 清屏
--  { key = 'k', mods = 'CTRL|SHIFT', action = act.ClearScrollback 'ScrollbackAndViewport' },
}

-- ============================================================
-- 滚动与性能
-- ============================================================
config.scrollback_lines = 20000
config.enable_scroll_bar = false
config.front_end = 'WebGpu'
config.animation_fps = 60
config.max_fps = 120

-- ============================================================
-- 鼠标与其他
-- ============================================================
config.mouse_wheel_scrolls_tabs = false  -- 滚轮只滚动内容
config.hide_mouse_cursor_when_typing = true
config.selection_word_boundary = " \t\n{}[]()\"'`"

config.audible_bell = 'Disabled'
config.check_for_updates = false

return config
