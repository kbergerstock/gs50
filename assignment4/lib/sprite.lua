--[[
    GD50
    -- Sprite Class --
    K.r.bergerstock
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor Animation
-- luacheck: ignore Sprite

require 'lib/Animation'

function Sprite(def)
    self = Animation()
    -- coodinates in tiles from bottom left corner (zero based)
    self.sx = def.sx
    self.sy = def.sy
    self.width = def.width
    self.height = def.height
    self.offset = def.offset
    self.texture = def.texture
    self.frames = def.frames
    self.sdx = 0
    self.Start(self,def.interval,def.playFrames)

    function self.update(self, dt)
        self.sdx = self.Animate(self, dt)
    end

    function self.move(self, dx, dy)
        self.sx = self.sx + dx
        self.sy = self.sy + dy
    end

    function self.constrain(self, left, right, up, down)
        if self.sx < left then self.sx = left elseif self.sx > right then self.sx = right end
        if self.sy > up then self.sy = up elseif self.sy < down then self.sy = down end
    end

    function self.render(self)
        if self.sdx > 0 then
            local mx = self.sx
            local my = self.offset - self.height - self.sy
            love.graphics.draw(self.texture,self.frames[self.sdx], mx, my)
        end
    end
    -- end of class defination
    return self
end