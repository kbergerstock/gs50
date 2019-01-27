-- dTimer.lua
-- k.r.bergerstock 2018.09
-- since we using a love2d engine it;s simmpler to base a timers on the love timer modules
-- time values are in millisconds

-- luacheck: allow_defined, no unused, globals Class love  o

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

dTimer = Class{}

function  dTimer:init(trigger)
    self.ms = 0
    self.trigger = trigger
end

function dTimer:elapsed(dt)
    -- convet dt to milliseconds and sum
    self.ms = self.ms + dt * 1000
    if self.ms >= self.trigger then
        self.ms = 0
        return true
    end
    return false
end