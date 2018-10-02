--[[
    GD50
    Super Mario Bros. Remake

    -- Snail Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Message StateMachine cHID Class setColor love GenerateQuads

Snail = Class{__includes = Entity}

function Snail:init(def)
    Entity.init(self, def)
end

function Snail:render(rcs)
    love.graphics.draw(rcs.gTextures[self.texture], rcs.gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 8, 0, self.direction == 'left' and 1 or -1, 1, 8, 10)
end