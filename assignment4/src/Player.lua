--[[
    GD50
    Super Mario Bros. Remake

    -- Player Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals love gCT Message Entity
-- luacheck: ignore Player

require 'src/Entity'

function Player(def)
    def.y = def.y + 1
    def.offset_x = 0
    def.offset_y = -5
    def.normal = 'right'
    def.name = 'Otarin'
    self = Entity(def)

    self.gravityOn = true
    self.gravityAmount = 6
    self.max_x = gCT.TILE_SIZE * 100 - self.width

    function self.update(self, dt)
        -- constrain player X no matter which state
        if self.x <= 8 then
            self.x = 8
        elseif self.x > self.max_x then
            self.x = self.max_x - 4
        end
    end

    -- verify
    -- needs a reference to the tile map
    function self.checkCollisions(self, game_level, dt)
        local map = game_level.tileMap
        -- check  two tiles in the current direction for collision
        -- look ahead is one pixel
        local x_save = self.x
        local tile_top = map:pointToTile(self.x + self.direction , self.y + 1)
        local tile_bottom = map:pointToTile(self.x + self.direction, self.y + self.height - 1)

        -- place player outside the X bounds on one of the tiles to reset any overlap
        if (tile_top and tile_bottom) and (tile_top:collidable() or tile_bottom:collidable()) then
            self.x = tile_top.sx + self.direction == 1 and -1 or tile_top.width -1
        else

            self.y = self.y - 1
            local collidedObjects = self:checkObjectCollisions()
            self.y = self.y + 1

            -- reset X if new collided object
            if #collidedObjects > 0 then
                self.direction = self.direction * -1
                self.x = x_save + self.direction -- self.x + self.direction * gCT.PLAYER_WALK_SPEED * dt
            end
        end
    end
    
    -- verify
    function self.checkObjectCollisions(self,objects)
        local collidedObjects = {}

        for k, object in pairs(objects) do
            if object:collides(self) then
                if object.solid then
                    table.insert(collidedObjects, object)
                elseif object.consumable then
                    object.onConsume(self)
                    table.remove(objects, k)
                end
            end
        end

        return collidedObjects
    end

    return self
end