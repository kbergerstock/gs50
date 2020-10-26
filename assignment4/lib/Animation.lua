-- animation classs
-- k.r.bergerstock

-- luacheck: allow_defined, no unused
-- luacheck: globals Class Animation
require 'lib/class'

Animation = Class{}

function Animation:init()
    self.playFrames = {}
    self.ndx = 0
    self.divisor = 1
    -- these will be stored as millseconds
    self.elapsed = 0
    self.interval = 55
end

function Animation:copyPlaylist(frames)
    self.divisor = 1
    -- copy in animation list
    for i, f in pairs(frames) do
        self.playFrames[i] = f
        self.divisor = self.divisor + 1
    end
end

function Animation:StartFrames(interval, frames)
    self:copyPlaylist(frames)
    -- set timner controls
    self.elapsed = 0
    self.interval = interval
    self.ndx = 1
end

function Animation:Stop()
    self.playFrames = {}
    self.divisor = 1
    self.ndx = 1
end

function Animation:setFrames(frames)
    self:copyPlaylist(frames)
    -- set timner controls
    self.elapsed = 0
    self.ndx = 1
end

-- this function updates and returns the index of the frame to be displayed
function Animation:Animate(dt)
    -- no need to update if animation is only one frame
    if self.divisor > 2 then
        self.elapsed = self.elapsed + dt * 1000
        if self.elapsed >= self.interval then
            self.elapsed = self.elapsed - self.interval
            self.ndx = self.ndx + 1
            if (self.ndx % self.divisor) == 0 then self.ndx = 1 end
        end
        return self.playFrames[self.ndx]
    elseif self.divisor == 2 then
        return self.playFrames[1]
    else
        self.ndx = 0
        return 0
    end
end