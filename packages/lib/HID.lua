--[[
    HID input class 
    k.r.bergerstock
]]

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

--  HID input class ------------------------------------------------------------
cHID = Class{}

-- a table we'll use to keep track of which keys have been pressed this
-- frame, to get around the fact that LOVE's default callback won't let us
-- test for input from within other functions
function cHID:init()
    self.inputs = {}
end

function cHID:reset()
    self.inputs = {}
end

function cHID:set(input)
    self.inputs[input] = true
end

function cHID:get(input)
    return self.inputs[input] or false
end

function cHID:getEnter()
    return self:get('enter') or self:get('return')
end

function cHID:isSpace()
    return self.inputs['space'] or false 
end

function cHID:isEscape()
    return self.inputs['escape'] or false 
end    

function cHID:leftButton()
    return self.inputs[2] or false 
end

function cHID:rightButton()
    return self.inputs[1] or false 
end

function cHID:middleButton()
    return self.inputs[3] or false 
end

function cHID:isPaused()
    return self.inputs['p'] or self.inputs['P'] or false 
end

























