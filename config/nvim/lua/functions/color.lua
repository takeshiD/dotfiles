local M = {}

local bit = require("bit")
local band = bit.band
local rshift = bit.rshift
local lshift = bit.lshift

---@param fg number foreground color
---@param bg number background color
---@param alpha number between 0.0 to 1.0. if aplha is out of range, this would be rounded between 0.0 to 1.0.
---@return number # colorcode mixed alpha
function M.composeColor(fg, bg, alpha)
    if (type(fg) ~= "number") then
        error(string.format("fg is not integer. Actually got = %s", fg))
    end
    if not (0 <= fg and fg <= 0xffffff) then
        error("fg is out of range between #000000 to #FFFFFF")
    end
    if (type(bg) ~= "number") then
        error(string.format("bg is not integer. Actually got = %s", bg))
    end
    if not (0 <= bg and bg <= 0xffffff) then
        error("bg is out of range between #000000 to #FFFFFF")
    end
    if type(alpha) ~= "number" then
        error("alpha is not number or integer, must be number or integer")
    end
    if not (0 <= alpha and alpha <= 1) then
        error("alpha is out of range between 0.0 to 1.0")
    end
    local fg_r = band(rshift(fg, 16), 0xFF)
    local fg_g = band(rshift(fg, 8), 0xFF)
    local fg_b = band(rshift(fg, 0), 0xFF)
    local bg_r = band(rshift(bg, 16), 0xFF)
    local bg_g = band(rshift(bg, 8), 0xFF)
    local bg_b = band(rshift(bg, 0), 0xFF)
    local r = math.floor(fg_r * (1 - alpha) + bg_r * alpha)
    local g = math.floor(fg_g * (1 - alpha) + bg_g * alpha)
    local b = math.floor(fg_b * (1 - alpha) + bg_b * alpha)
    local compose = (lshift(r, 16) + lshift(g, 8) + lshift(b, 0))
    return compose
end

---@param dec integer expression colorcode by decimal
---@return string colorcode by triplex
function M.dec2triplex(dec)
    if type(dec) ~= "number" then
        error("dec is not number")
    end
    if not (0 <= dec and dec <= 0xffffff) then
        error(string.format("dec out of range between #000000 to #FFFFFF. Got dec = #%06x", dec))
    end
    return ("#%06x"):format(dec)
end

return M
