--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love gRC

GameObject = Class{}

function GameObject:init(def)
    self.tx = def.x - 1
    self.ty = def.y - 1
    self.width = def.width
    self.height = def.height
    self.texture = def.texture
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.hit = def.hit
    self.size = def.tile_size
    self.mx = self.tx * self.size
    self.my = self.ty * self.size
end

function GameObject:update(dt) end

function GameObject:render()
    local sx = self.mx
    local sy = 146 - self.my
    love.graphics.draw(gRC.textures[self.texture], gRC.frames[self.texture][self.frame],sx,sy)
end
