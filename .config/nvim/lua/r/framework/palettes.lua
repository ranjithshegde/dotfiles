-- Base16 palettes for mini.base16
-- Semantic slots:
--   base00-03  background shades (darkest → UI chrome)
--   base04-07  foreground shades (comments → brightest fg)
--   base08     variables / red
--   base09     orange / numbers
--   base0A     yellow / types
--   base0B     green / strings
--   base0C     cyan / regex
--   base0D     blue / functions
--   base0E     purple / keywords
--   base0F     brown / deprecated / embedded

local M = {}

-- ── Tokyo Night Storm ────────────────────────────────────────────────
-- Closest base16 approximation of folke/tokyonight.nvim (storm variant)
M.tokyonight_storm = {
    base00 = '#24283b', -- bg
    base01 = '#1f2335', -- bg_dark
    base02 = '#292e42', -- bg_highlight
    base03 = '#565f89', -- comments
    base04 = '#737aa2', -- dark5
    base05 = '#c0caf5', -- fg
    base06 = '#c0caf5', -- fg_bright (same; storm doesn't go brighter)
    base07 = '#a9b1d6', -- fg_dark
    base08 = '#f7768e', -- red (variables)
    base09 = '#ff9e64', -- orange (numbers)
    base0A = '#e0af68', -- yellow (types)
    base0B = '#9ece6a', -- green (strings)
    base0C = '#73daca', -- cyan (regex)
    base0D = '#7aa2f7', -- blue (functions)
    base0E = '#bb9af7', -- purple (keywords)
    base0F = '#9d7cd8', -- magenta (embedded / deprecated)
}

-- ── Neko Night Moon ──────────────────────────────────────────────────
-- Faithful base16 translation of neko-night/nvim moon variant
M.nekonight_moon = {
    base00 = '#222436', -- bg
    base01 = '#1e2030', -- bg_dark
    base02 = '#2f334d', -- bg_highlight
    base03 = '#636da6', -- comments
    base04 = '#828bb8', -- dark5
    base05 = '#c8d3f5', -- fg
    base06 = '#e3e6f2', -- fg_bright
    base07 = '#a9b8e8', -- fg_dark
    base08 = '#ff757f', -- red
    base09 = '#ff966c', -- orange
    base0A = '#ffc777', -- yellow
    base0B = '#c3e88d', -- green
    base0C = '#86e1fc', -- cyan
    base0D = '#82aaff', -- blue
    base0E = '#c099ff', -- purple
    base0F = '#b4f9f8', -- teal (embedded)
}

-- ── Rose Pine Moon ───────────────────────────────────────────────────
-- Classic moonlight-toned dark, softer contrast than tokyo variants
M.rose_pine_moon = {
    base00 = '#232136', -- base
    base01 = '#2a273f', -- surface
    base02 = '#393552', -- overlay
    base03 = '#6e6a86', -- muted
    base04 = '#908caa', -- subtle
    base05 = '#e0def4', -- text
    base06 = '#e0def4', -- (same; no brighter fg in palette)
    base07 = '#56526e', -- highlight high
    base08 = '#eb6f92', -- love (red)
    base09 = '#f6c177', -- gold (orange)
    base0A = '#ea9a97', -- rose (warm pink / type)
    base0B = '#3e8fb0', -- pine (green-teal / strings)  ← intentional non-green
    base0C = '#9ccfd8', -- foam (cyan)
    base0D = '#c4a7e7', -- iris (purple / functions)
    base0E = '#94e8f2', -- dawn (yellow-pink / keywords)
    base0F = '#56526e', -- muted (deprecated)
}

-- ── Catppuccin Mocha ─────────────────────────────────────────────────
-- Warm, low-contrast dark; good for long sessions
M.catppuccin_mocha = {
    base00 = '#1e1e2e', -- base
    base01 = '#181825', -- mantle
    base02 = '#313244', -- surface0
    base03 = '#45475a', -- surface1
    base04 = '#585b70', -- surface2
    base05 = '#cdd6f4', -- text
    base06 = '#f5e0dc', -- rosewater
    base07 = '#b4befe', -- lavender
    base08 = '#f38ba8', -- red
    base09 = '#fab387', -- peach
    base0A = '#f9e2af', -- yellow
    base0B = '#a6e3a1', -- green
    base0C = '#94e2d5', -- teal
    base0D = '#89b4fa', -- blue
    base0E = '#cba6f7', -- mauve (keywords)
    base0F = '#f2cdcd', -- flamingo
}

-- ── One Dark ─────────────────────────────────────────────────────────
-- Atom-lineage; muted midtones, easy on the eyes
M.onedark = {
    base00 = '#1e222a', -- bg
    base01 = '#353b45', -- bg2
    base02 = '#3e4451', -- bg3
    base03 = '#545862', -- comments
    base04 = '#565c64', -- gutter
    base05 = '#abb2bf', -- fg
    base06 = '#b6bdca', -- fg2
    base07 = '#c8ccd4', -- fg3
    base08 = '#e06c75', -- red
    base09 = '#d19a66', -- orange
    base0A = '#e5c07b', -- yellow
    base0B = '#98c379', -- green
    base0C = '#56b6c2', -- cyan
    base0D = '#61afef', -- blue
    base0E = '#c678dd', -- purple
    base0F = '#be5046', -- dark red (embedded)
}

return M
