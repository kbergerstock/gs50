--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love
-- luacheck: globals gFonts gTextures gFrames gSounds

GameObject = Class{}

function GameObject:init(def)
    self:initialize(def)
end

function GameObject:initialize(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)

end

function GameObject:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
end

GemObject = Class{__includes = GameObject }

function GemObject:init(def)
    self:initialize(def)
    self.w = self.y
    self.timer = dTimer(55)
end

function GemObject:update(dt)
    -- every 55 milliseconds move gem up 1
    -- remember the y axis is inverted , higher numbers are closer to the virtual ground
    if self.y > self.w and self.timer(dt) then
        self.y = self.y - 1
    end
end
