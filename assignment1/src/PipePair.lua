--[[
    PipePair Class

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used to represent a pair of pipes that stick together as they scroll, providing an opening
    for the player to jump through in order to score a point.
]]
-- luacheck: allow_defined,no unused
-- luacheck: globals love Class Pipe
-- luacheck: globals WINDOW_WIDTH WINDOW_HEIGHT VIRTUAL_WIDTH VIRTUAL_HEIGHT
-- luacheck: globals PIPE_SPEED PIPE_WIDTH PIPE_HEIGHT
-- luacheck: globals BIRD_WIDTH BIRD_HEIGHT COUNTDOWN_TIME

PipePair = Class{}

-- size of the gap between pipes
local GAP_HEIGHT = 90
-- orientation of the image
local TOP  = -1
local BOTTOM =  1

function PipePair:init(y, gap)
    -- flag to hold whether this pair has been scored (jumped through)
    self.scored = false

    -- initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32

    -- y value is for the topmost pipe; gap is a vertical shift of the second lower pipe
    self.y = y + PIPE_HEIGHT
    local yb = self.y + GAP_HEIGHT + math.random(0,gap)
    if yb > (PIPE_HEIGHT -15) then yb = PIPE_HEIGHT - 15 end
    -- instantiate two pipes that belong to this pair
    self.pipes = {
        ['upper'] = Pipe( TOP, self.y ),
        ['lower'] = Pipe( BOTTOM, yb )
    }

    -- whether this pipe pair is ready to be removed from the scene
    self.remove = false
end

function PipePair:update(dt)
    -- remove the pipe from the scene if it's beyond the left edge of the screen,
    -- else move it from right to left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for l, pipe in pairs(self.pipes) do
        pipe:render()
    end
end

