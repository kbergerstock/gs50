-- loveTimer.lua
-- k.r.bergerstock 2018.09
-- since we using a love2d engine it;s simmpler to base a timers on the love timer modules
-- time values are in millisconds

-- luacheck: allow_defined, no unused, globals Class love  o

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

loveTimer = Class{}

function  loveTimer:set(trigger)
    self._trigger = trigger
end

function loveTimer:reset()
    self._st = love.timer.getTime()
end

function loveTimer:start(trigger)
    self._st = love.timer.getTime()
    self._trigger = trigger
end

function loveTimer:elapsed()
    -- convet dt to milliseconds
    local et = love.timer.getTime()
    local dt = (et - self._st) * 1000
    if dt >= self._trigger then
        self._st = et
        return true
    end
    return false
end