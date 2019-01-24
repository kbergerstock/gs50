--[[
    HID input class
    k.r.bergerstock
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals Class  readOnly

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

--  HID input class ------------------------------------------------------------
Inputs = Class{}

-- a table we'll use to keep track of which keys have been pressed this
-- frame, to get around the fact that LOVE's default callback won't let us
-- test for input from within other functions
function Inputs:init()
    self.inputs = {}
end

function Inputs:reset()
    self.inputs = {}
end

function Inputs:set(input)
    self.inputs[input] = true
end

function Inputs:get(input)
    return self.inputs[input] or false
end

function Inputs:getEnter()
    return self:get('enter') or self:get('return')
end

function Inputs:isSpace()
    return self.inputs['space'] or false
end

function Inputs:isEscape()
    return self.inputs['escape'] or false
end

function Inputs:leftButton()
    return self.inputs[2] or false
end

function Inputs:rightButton()
    return self.inputs[1] or false
end

function Inputs:middleButton()
    return self.inputs[3] or false
end

























