--[[
    GD50
    Super Mario Bros. Remake

    -- Animation Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts

require 'lib/loveTimer'

Animation = Class{__includes = loveTimer}

function Animation:init()
    self.frames = {}
    self.ndx = 1
    self.divisor = 1
    self.current_frame = 0
end

function Animation:Start(interval, frames)
    self.ndx = 1
    -- set the trigger in milliseconds
    self:set(interval)
    if frames ~= nil then
        self:setFrames(frames)
    end
end

function Animation:setFrames( Frames)
    self.frames = Frames
    self.divisor = 1 + #Frames
    if self.divisor > 2 then
        -- start the timer
        self:reset()
        -- init frame to be rendered
        self.current_frame = self.frames[self.ndx]
    elseif self.divisor == 2 then
        self.current_frame = self.frames[1]
    else
        self.current_frame = 0
    end
end

function Animation:Stop()
    self.frames = {}
    self.divisor = 1
    self.current_frame = 0
end

function Animation:update()
    -- no need to update if animation is only one frame
    if self.divisor > 2 then
        if self:elapsed() then
            self.ndx = self.ndx + 1
            if (self.ndx % self.divisor) == 0 then  self.ndx = 1 end
            self.current_frame = self.frames[self.ndx]
        end
    end
end

function Animation:get_current_frame()
    return self.current_frame
end

