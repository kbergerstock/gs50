--[[
    keyboard input class 
    k.r.bergerstock
]]

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

Keyboard = Class{}

-- a table we'll use to keep track of which keys have been pressed this
-- frame, to get around the fact that LOVE's default callback won't let us
-- test for input from within other functions
function Keyboard:init()
    self.keysPressed = {}
end

function Keyboard:reset()
    self.keysPressed = {}
end

function Keyboard:set(key)
    self.keysPressed[key] = true
end

function Keyboard:get(key)
    return self.keysPressed[key] or false
end

function Keyboard:getEnter()
    return self:get('enter') or self:get('return')
end

function Keyboard:getSpace()
    return self:get('space')
end

function Keyboard:getEscape()
    return self:get('escape')
end    




























