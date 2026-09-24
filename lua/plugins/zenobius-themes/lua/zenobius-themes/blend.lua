-- Alpha blend of two hex colours.
--
-- The vendored rose-pine highlight table marks some groups with `blend = N`.
-- Upstream resolves that mark into a flat `bg` before it calls
-- `nvim_set_hl`, because `nvim_set_hl`'s own `blend` field only applies to
-- floating windows. This file does the same resolution.
--
-- Upstream reads each colour with `nvim_get_color_by_name`, so it accepts
-- names such as "red". Every colour in the vendored tables is a `#rrggbb`
-- string, so this parses hex directly and needs no Neovim call.

---@param hex string a `#rrggbb` colour
---@return integer r, integer g, integer b
local function to_rgb(hex)
  local value = tonumber(hex:sub(2), 16)
  return math.floor(value / 65536) % 256, math.floor(value / 256) % 256, value % 256
end

---Mix `fg` over `bg`.
---@param fg string `#rrggbb` foreground
---@param bg string `#rrggbb` background
---@param alpha number 0 gives `bg`, 1 gives `fg`
---@return string `#RRGGBB`
return function(fg, bg, alpha)
  local fr, fg_, fb = to_rgb(fg)
  local br, bg_, bb = to_rgb(bg)

  local function channel(f, b)
    local mixed = alpha * f + (1 - alpha) * b
    return math.floor(math.min(math.max(0, mixed), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", channel(fr, br), channel(fg_, bg_), channel(fb, bb))
end
