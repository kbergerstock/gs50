-- timer.lua
-- k.r.bergerstock 2018.09
-- since we using a love2d engine it;s simmpler to base a timers on the love timer modules
-- time values are in millisconds

-- luacheck: allow_defined, no unused, globals Class setColor love BaseState o
-- luacheck: ignore VIRTUAL_WIDTH VIRTUAL_HEIGHT WINDOW_WIDTH WINDOW_HEIGHT

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

Timer = Class{}

function Timer:init()
    self.start = 0.0
    self.elapsed = 0.0
    self.trigger = 0.0
    self.event = false
end

function Timer:Start(trigger)
    self.start = love.timer.getTime()
    self.trigger = trigger
    self.event = false
end

function Timer:Elapsed()
    return (love.getTime() - self.start) * 1000
end

function Timer:update()
    self.elapsed = love.Timer.getTime()
    if (self.elapsed - self.start) * 1000 > self.trigger then
        self.event = true
    end
    return self.event
end

function Timer:run( dotask )
    self.elapsed = love.Timer:getTime()
    if (self.elapsed - self.start) * 1000 > self.trigger then
        dotask()
        self.start = self.elapsed
    end
end

