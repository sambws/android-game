--[[
LÖVE-Android on Desktop Shim
============================
for debugging/testing android games on a desktop environment

Features
--------
- Two touchscreen behaviours ("single" and "multi")
- Touchpoint overlay (disables love.mouse.setVisible for convenience)
- Keyboard wrapper, keybinds for menu/back/return/search/textinput
- love.touchgestured that may work (somebody should make a demo or something)

Non-features
------------
- Overriding love.draw later in the code will disable drawing
    - Call lads.draw manually and pass "false" as the second argument to lads.hook
- GLES shader code may differ and be incompatible in some ways (it's a subset
though, so it should work in most cases)

Usage
-----
Add
`require("lads").hook()`
to the very end of main.lua (or after love.draw is defined).
You can pass a string to switch between simple "single" behaviour and
(unintuitive) "multi" behaviour.
By default, F5 to F9 are mapped to the Android menu/back/return/search/toggle
keyboard keys, respectively.
You can change this by modifying lads.keys["menu/back/return/search/textinput"].

single:
A left mousedown event will create a touchpoint on the screen and fire
touchpressed. The point will follow the cursor and will be touchreleased
together with the button.

multi:
Behaves like single until the mouse button is released. The touchpoints now
stays on the screen and can be dragged with the left mouse button. Multiple
touchpoints (up to lads.touchlimit) can be created and touchreleased by clicking
them with the right mouse button.

(c) 2015 by nucular
MIT Licensed
]]--

local lads = {}

lads.mode = "single"
lads.touches = {}
lads.size = 20
lads.touchlimit = 10

lads.textinput = nil

lads.keys = {
    ["menu"] = "f5",
    ["back"] = "f6",
    ["return"] = "f7",
    ["search"] = "f8",
    ["textinput"] = "f9"
}
lads.handlers = {}

local BLOCK_EVENT = true
local PASS_EVENT = false

local function dist(ax, ay, bx, by)
    return math.sqrt((bx - ax)^2 + (by - ay)^2)
end

local function hsv(h, s, v, a)
  local r, g, b

  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255, a * 255
end

local function idpairs()
    local i = 1

    return function()
        if i > lads.touchlimit then
            return nil
        end
        while i <= lads.touchlimit do
            if lads.touches[i] then
                j = i
                i = i + 1
                return j-1, lads.touches[j]
            else
                i = i + 1
            end
        end
    end
end

local function idcount()
    local count = 0
    for i=1, lads.touchlimit do
        if lads.touches[i] then
            count = count + 1
        end
    end
    return count
end

local function nthtouch(id)
    local count = 0
    for i=1, lads.touchlimit do
        if lads.touches[i] then
            count = count + 1
            if count == id then
                local touch = lads.touches[i]
                return i, touch.x, touch.y, touch.pressure
            end
        end
    end
    return nil
end

local function newid()
    for i=1, lads.touchlimit do
        if not lads.touches[i] then
            return i-1
        end
    end
    return lads.touchlimit-1
end

local function lastid()
    for i=1, lads.touchlimit do
        if lads.touches[i] and not lads.touches[i + 1] then
            return i-1
        end
    end
    return nil
end

function lads.hook(mode, draw)
    lads.setMode(mode or "single")

    local _poll = love.event.poll
    love.event.poll = function()
        local _iter = _poll()
        local function iter()
            local blocked = PASS_EVENT

            local e, a, b, c, d = _iter()
            if not e then return end

            if lads.handlers[e] then
                blocked, a, b, c, d = lads.handlers[e](a, b, c, d)
            end

            if blocked == BLOCK_EVENT then
                return iter()
            else
                return e, a, b, c, d
            end
        end

        return iter
    end

    love.system.getOS = function()
        return "Android"
    end

    love.system.vibrate = function(seconds)
        -- TODO: Translate randomly for [seconds]?
    end

    if love.window then
        love.window.isTouchScreen = function(display)
            return true
        end
    end

    if love.keyboard then
        love.keyboard.setTextInput = function(enable, x, y, width, height)
            if enable then
                lads.textinput = {x = x, y = y, width = width, height = height}
            else
                lads.textinput = nil
            end
        end

        love.keyboard.hasTextInput = function()
            return lads.textinput ~= nil
        end

        local _isDown = love.keyboard.isDown
        love.keyboard.isDown = function(...)
            local args = {...}
            for i,v in ipairs(args) do
                args[i] = lads.keys[v] or v
            end
            return unpack(args)
        end
    end

    if love.mouse then
        love.mouse.isDown = function(...)
            for i,v in ipairs({...}) do
                if v == "l" then
                    for j,w in idpairs() do
                        return true
                    end
                end
            end
            return false
        end

        -- Disable mouse hiding for touchpoint UI
        love.mouse.setVisible(true)
        local fakevisible = true
        love.mouse.isVisible = function()
            return fakevisible
        end

        love.mouse.setVisible = function(s)
            fakevisible = s
        end
    end

    love.touch = {}
    love.touch.getTouchCount = idcount
    love.touch.getTouch = nthtouch

    if draw == nil or draw == true then
        local _draw = love.draw
        love.draw = function()
            if _draw then _draw() end

            local _color = {love.graphics.getColor()}
            love.graphics.setCanvas()
            love.graphics.origin()
            lads.draw()
            love.graphics.setColor(_color)
        end
    end
end

function lads.handlers.mousepressed(x, y, button)
    if lads.textinput and
        x >= (lads.textinput.x or 0) and
        y >= (lads.textinput.y or love.graphics.getHeight() / 2) and
        x < (lads.textinput.width or love.graphics.getWidth()) and
        y < (lads.textinput.height or love.graphics.getHeight()) then
        return BLOCK_EVENT
    end
    if lads.mode == "single" then
        if button == "l" then
            lads.pressTouch(
                newid(),
                x / love.graphics.getWidth(),
                y / love.graphics.getHeight(),
                1
            )
        else
            return BLOCK_EVENT
        end
    elseif lads.mode == "multi" then
        if button == "l" then
            local touched = false
            for i,v in idpairs() do
                if dist(x, y, v.x * love.graphics.getWidth(), v.y * love.graphics.getHeight()) <= lads.size then
                    v.md = true
                    touched = true
                end
            end

            if not touched then
                local i = newid()
                lads.pressTouch(
                    i,
                    x / love.graphics.getWidth(),
                    y / love.graphics.getHeight(),
                    1
                )
                lads.touches[i+1].md = true
                return PASS_EVENT, x, y, button, true
            else
                return BLOCK_EVENT
            end
        else
            return BLOCK_EVENT
        end
    end
end

function lads.handlers.mousereleased(x, y, button)
    if lads.textinput and
        x >= (lads.textinput.x or 0) and
        y >= (lads.textinput.y or love.graphics.getHeight() / 2) and
        x < (lads.textinput.width or love.graphics.getWidth()) and
        y < (lads.textinput.height or love.graphics.getHeight()) then
        return BLOCK_EVENT
    end
    if lads.mode == "single" then
        if button == "l" then
            lads.releaseTouch(
                lastid(),
                x / love.graphics.getWidth(),
                y / love.graphics.getHeight(),
                1
            )
        end
    elseif lads.mode == "multi" then
        if button == "l" then
            local touched = false
            for i,v in idpairs() do
                if v.md then touched = true end
                v.md = false
            end
            if touched then
                return BLOCK_EVENT
            else
                return PASS_EVENT, x, y, button, true
            end
        elseif button == "r" then
            local touched = false
            for i,v in idpairs() do
                if dist(x, y, v.x * love.graphics.getWidth(), v.y * love.graphics.getHeight()) <= lads.size then
                    lads.releaseTouch(
                        i,
                        v.x,
                        v.y,
                        1
                    )
                    touched = true
                end
            end
            if not touched then
                return BLOCK_EVENT
            else
                return PASS_EVENT, x, y, button, true
            end
        end
    end
    return PASS_EVENT, x, y, button, false
end

function lads.handlers.mousemoved(x, y, dx, dy)
    if lads.textinput and
        x >= (lads.textinput.x or 0) and
        y >= (lads.textinput.y or love.graphics.getHeight() / 2) and
        x < (lads.textinput.width or love.graphics.getWidth()) and
        y < (lads.textinput.height or love.graphics.getHeight()) then
        return BLOCK_EVENT
    end
    if lads.mode == "single" then
        if #lads.touches > 0 then
            lads.moveTouch(
                0,
                x / love.graphics.getWidth(),
                y / love.graphics.getHeight(),
                1
            )
        end
    elseif lads.mode == "multi" then
        local touched = false
        for i,v in idpairs() do
            if v.md then
                lads.moveTouch(
                    i,
                    x / love.graphics.getWidth(),
                    y / love.graphics.getHeight(),
                    1
                )
                touched = true
            end
        end
        if not touched then
            return BLOCK_EVENT
        else
            return PASS_EVENT, x, y, dx, dy
        end
    end
end

function lads.handlers.keypressed(key, isrepeat)
    if key == lads.keys["menu"] then
        if not isrepeat then return PASS_EVENT, "menu", false end
    elseif key == lads.keys["back"] then
        if not isrepeat then return PASS_EVENT, "back", false end
    elseif key == lads.keys["return"] then
        if not isrepeat then return PASS_EVENT, "return", false end
    elseif key == lads.keys["search"] then
        if not isrepeat then return PASS_EVENT, "search", false end
    elseif key == lads.keys["textinput"] then
        if not isrepeat and love.keyboard and love.keyboard.setTextInput then
            love.keyboard.setTextInput(not love.keyboard.hasTextInput())
        end
        return BLOCK_EVENT
    else
        return PASS_EVENT, key, isrepeat
    end
end

function lads.handlers.keyreleased(key, isrepeat)
    if key == lads.keys["menu"] then
        if not isrepeat then return PASS_EVENT, "menu", false end
    elseif key == lads.keys["back"] then
        if not isrepeat then return PASS_EVENT, "home", false end
    elseif key == lads.keys["return"] then
        if not isrepeat then return PASS_EVENT, "return", false end
    elseif key == lads.keys["search"] then
        if not isrepeat then return PASS_EVENT, "search", false end
    elseif key == lads.keys["textinput"] then
        return BLOCK_EVENT
    else
        return PASS_EVENT, key, isrepeat
    end
end


function lads.pressTouch(id, x, y, p)
    lads.touches[id+1] = {
        x = x, y = y,
        p = p,
        md = false
    }
    if love.touchpressed then love.touchpressed(id, x, y, p) end
end

function lads.releaseTouch(id, x, y, p)
    lads.touches[id+1] = nil
    if love.touchreleased then love.touchreleased(id, x, y, p) end
end

function lads.moveTouch(id, x, y, p)
    local v = lads.touches[id+1]

    if love.touchgestured then
        local idc = idcount()
        if idc >= 2 then
            -- Centroid
            local cx, cy = 0, 0
            for i, v in idpairs() do
                cx = cx + v.x
                cy = cy + v.y
            end
            cx = cx / idc
            cy = cy / idc

            -- Vector centroid > old v.x
            local lvx = v.x - cx
            local lvy = v.y - cy
            local ldist = math.sqrt(lvx * lvx + lvy * lvy)
            -- Vector centroid > new v.x
            local vx = x - cx
            local vy = y - cy
            local dist = math.sqrt(vx * vx + vy * vy)

            -- Normalize vectors
            lvx = lvx / ldist
            lvy = lvy / ldist
            vx = vx / dist
            vy = vy / dist

            -- Calculate gesture
            local dtheta = math.atan2(lvx * vy - lvy * vx, lvx * vx + lvy * vy)
            local ddist = dist - ldist
            if ldist == 0 then
                ddist = 0
                dtheta = 0
            end

            love.touchgestured(cx, cy, dtheta, ddist, idc)
        end
    end

    v.x = x
    v.y = y
    v.p = p
    if love.touchmoved then love.touchmoved(id, x, y, p) end
end


function lads.draw()
    for i,v in idpairs() do
        love.graphics.setColor(hsv(i / lads.touchlimit, 1, 0.5, 0.5))
        love.graphics.circle(
            "fill",
            v.x * love.graphics.getWidth(),
            v.y * love.graphics.getHeight(),
            lads.size
        )
        love.graphics.setColor(255, 255, 255, 70)
        love.graphics.circle(
            "line",
            v.x * love.graphics.getWidth(),
            v.y * love.graphics.getHeight(),
            lads.size
        )
    end
    if lads.textinput then
        love.graphics.setColor(100, 100, 100, 100)
        love.graphics.rectangle("fill",
            lads.textinput.x or 0,
            lads.textinput.y or love.graphics.getHeight() / 2,
            lads.textinput.width or love.graphics.getWidth(),
            lads.textinput.height or love.graphics.getHeight() / 2
        )

        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(
            "On-screen Keyboard",
            lads.textinput.x or 0,
            (lads.textinput.y or love.graphics.getHeight() / 2 + 10)
                + (lads.textinput.height or love.graphics.getHeight() / 2) / 2,
            lads.textinput.width or love.graphics.getWidth(),
            "center"
        )
    end
end

function lads.setMode(mode)
    assert(mode == "single" or mode == "multi", string.format("Mode %s not supported", mode))
    lads.touches = {}
    lads.mode = mode
end

return lads
