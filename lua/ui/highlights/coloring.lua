---@alias plugin.color string | number | number[] | fun(): string | number | number[]

local coloring = {}

------------------------------------------------------------------------------
-- Core Color Math
------------------------------------------------------------------------------

--- Evaluates and converts a color input into a standard RGB table.
--- Handles strings (#RRGGBB), decimals, RGB arrays, and dynamic functions.
---@param val plugin.color
---@param ... any
---@return integer[]
function coloring.parse(val, ...)
  if type(val) == "string" then
    local r, g, b = string.match(val:lower(), "^#?(..?)(..?)(..?)$")
    return { tonumber(r, 16) or 0, tonumber(g, 16) or 0, tonumber(b, 16) or 0 }
  elseif type(val) == "number" then
    local hex = string.format("%06x", val)
    local r, g, b = string.match(hex, "^(..?)(..?)(..?)$")
    return { tonumber(r, 16) or 0, tonumber(g, 16) or 0, tonumber(b, 16) or 0 }
  elseif vim.islist(val) and type(val[1]) == "number" then
    return val
  elseif type(val) == "function" then
    local s, _val = pcall(val, ...)
    return (s and type(_val) ~= "function") and coloring.parse(_val, ...) or { 0, 0, 0 }
  end
  return { 0, 0, 0 }
end

--- Converts an RGB table back to a standard Hex string.
---@param rgb integer[]
---@return string
function coloring.hex(rgb)
  return string.format(
    "#%02x%02x%02x", math.min(255, math.max(0, rgb[1] or 0)),
    math.min(255, math.max(0, rgb[2] or 0)), math.min(255, math.max(0, rgb[3] or 0))
  )
end

--- Blends a foreground color into a background color based on an alpha ratio.
---@param fg    plugin.color
---@param bg    plugin.color
---@param alpha number
---@return string
function coloring.blend(fg, bg, alpha)
  local bg_rgb = coloring.parse(bg)
  local fg_rgb = coloring.parse(fg)

  local blend = function (i)
    return math.floor((alpha * fg_rgb[i]) + ((1 - alpha) * bg_rgb[i]))
  end

  return coloring.hex({ blend(1), blend(2), blend(3) })
end

--- Generates an array of hex colors interpolated between two points.
---@param from_color plugin.color
---@param to_color   plugin.color
---@param steps      integer
---@return string[]
function coloring.gradient(from_color, to_color, steps)
  local from = coloring.parse(from_color)
  local to = coloring.parse(to_color)

  local function lerp(n, y)
    local _from, _to = from[n] or 0, to[n] or 0
    return math.floor(_from + ((_to - _from) * y))
  end

  local gradient = {}
  local corrected_steps = math.max(1, steps - 1)

  for s = 0, corrected_steps do
    local multiplier = s / corrected_steps
    local color = coloring.hex({ lerp(1, multiplier), lerp(2, multiplier), lerp(3, multiplier) })
    table.insert(gradient, color)
  end

  return gradient
end

return coloring
