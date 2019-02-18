-- animation classs
-- k.r.bergerstock

-- luacheck: allow_defined, no unused
-- luacheck: ignore Animation

function Animation()
    local self = {}
    self.playFrames = {}
    self.ndx = 0
    self.divisor = 1
    -- these will be stored as millseconds
    self.elapsed = 0
    self.interval = 0


    function self.Start(self, interval, frames)
        self.playFrames = frames
        self.divisor = 1
        if self.playFrames ~= nil then
            self.elapsed = 0
            self.interval = interval
            self.divisor = 1 + #frames
            self.ndx = 1
        else
            self.ndx = 0
        end
    end

    function self.Stop(self)
        self.playFrames = {}
        self.divisor = 1
        self.ndx = 0
    end

    function self.Reset(self, frames)
        self.playFrames = frames
        self.divisor = 1
        if self.playFrames ~= nil then
            self.elapsed = 0
            self.divisor = 1 + #frames
            self.ndx = 1
        else
            self.ndx = 0
        end
    end

    -- this function updates and returns the index of the frame to be displayed
    function self.Animate(self, dt)
        -- no need to update if animation is only one frame
        if self.divisor > 2 then
            self.elapsed = self.elapsed + dt * 1000
            if self. elapsed >= self.interval then
                self.elapsed = self.elapsed - self.interval
                self.ndx = self.ndx + 1
                if (self.ndx % self.divisor) == 0 then  self.ndx = 1 end
            end
            return self.playFrames[self.ndx]
        elseif self.divisor == 2 then
            self.ndx = 1
            return self.playFrames[self.ndx]
        else
            self.ndx = 0
            return  0
        end
    end
    return self
end