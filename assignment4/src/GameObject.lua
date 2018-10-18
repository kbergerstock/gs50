--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love
-- luacheck: globals gFonts gTextures gFrames gSounds gCT

GameObject = Class{}

function GameObject:init(def)
    self.tx = def.x
    self.ty = def.y
    self.width = def.width
    self.height = def.height
    self.texture = def.texture
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
    self.size = def.tile_size
end

function GameObject:collides(target) end

function GameObject:update(dt) end

function GameObject:render(origin_x)
    local sx = ((self.tx - origin_x  )- 1) * self.size
    local sy = (10 - self.ty) * self.size
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], sx, sy)
end
