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
        self.sdx = self.animate(self, dt)
    end

    function self.move(dx, dy)
        self.sx = self.sx + dx
        self.sy = self.sy + dy
    end

    function self.render(self)
        local mx = self.sx
        local my = self.offset - self.sx - self.height
        if self.sdx > 0 then
            love.graphics.draw(self.texture,self.frames[self.sdx],mx,my)
        end
    end
    -- end of class defination
    return self
end