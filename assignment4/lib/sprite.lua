--[[
    GD50
    -- Sprite Class --
    K.r.bergerstock
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor Animation BBox
-- luacheck: ignore Sprite

require 'lib/Animation'
require 'lib/BBox'

Sprite = Class{__includes ={ Animation, BBox} }

function Sprite:init(def)
    -- coodinates in tiles from bottom left corner (zero based)
    Animation.init(self,def)
    BBox.init(self)
    self.sx = def.sx
    self.sy = def.sy
    self.width = def.width
    self.height = def.height
    self.offset = def.offset
    self.texture = def.texture
    self.frames = def.frames
    self.sdx = 0
    self:StartFrames(def.interval, def.playFrames)
    self:setBox(def.sx, def.sy, def.width, def.height)
end

function Sprite:update(dt)
    self.sdx = self:Animate(dt)
end

function Sprite:move(dx, dy)
    self.sx = self.sx + dx
    self.sy = self.sy + dy
    self:setBox(self.sx, self.sy, self.width, self.height)
end

function Sprite:constrain( left, right, up, down)
    if self.sx < left then self.sx = left elseif self.sx > right then self.sx = right end
    if self.sy > up then self.sy = up elseif self.sy < down then self.sy = down end
end

function Sprite:render()
    if self.sdx > 0 then
        local mx = self.sx
        local my = self.offset - self.height - self.sy
        love.graphics.draw(self.texture,self.frames[self.sdx], mx, my)
    end
end