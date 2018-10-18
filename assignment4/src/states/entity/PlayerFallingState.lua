--[[
    GD50
    Super Mario Bros. Remake

    -- PlayerFallingState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts gCT

PlayerFallingState = Class{__includes = BaseState}

function PlayerFallingState:init(tile_map, objects, entities)
    self.map = tile_map
    self.objects = objects
    self.entities = entities
    self.animation = Animation {
        frames = {3},
        interval = 1
    }
end

function PlayerFallingState:enter(msg)
    assert(msg.name()== 'Otarin','OOPS a non player is acessing a player state -> '..msg.name())
    msg.currentFrame = self.animation:getCurrentFrame()
end

-- the msg packet IS the player
function PlayerFallingState:update(msg, dt)
    self.animation:update(dt)
    msg.dy = msg.dy + msg.gravity
    msg.y = msg.y + (msg.dy * dt)
     
    -- NOTE should there be an x component 
    if love.keyboard.isDown('left') then
        msg.direction = -1
        msg.nextState('player_walking')
    elseif love.keyboard.isDown('right') then
        msg.direction = 1
        msg.nextState('player_walking')
    elseif msg.dy == 0 then
        -- idle if we're not pressing anything at all
        msg.direction = 0
        msg.nextState('player_idle')
    end
    if dy > 0 then
        -- look at two tiles below our feet and check for collisions
        local tile_bottom1 = self.map:pointToTile(msg.x + msg.direction * 3, msg.y + msg.height)
        local tile_botyom2 = self.map:pointToTile(msg.x + msg.direction * (msg.width +3 ) , msg.y + msg.height)

        -- if we get a collision beneath us, go into either walking or idle
        if (tile_bottom1 and tile_bottom) and (tile_bottom1:collidable() or tile_bottom2:collidable()) then
            msg.dy = 0

            -- check side collisions and reset position
            msg.y = tile_bottom1.sy - msg.height
            msg.checkCollisions(self.game_level, dt)

        -- go back to start if we fall below the map boundary
        elseif msg.y > self.VH then
            gSounds['death']:play()
            msg.next_state('player_dead')
        end
        -- check if we've collided with any collidable game objects
        for k, object in pairs(self.game_level.objects) do
            if object:collides(msg) then
                if object.solid then
                    msg.dy = 0
                    msg.y = object.y - msg.height
                elseif object.consumable then
                    object.onConsume(msg)
                    table.remove(self.game_level.objects, k)
                end
            end
        end

        -- check if we've collided with any entities and kill them if so
        for k, entity in pairs(self.game_level.entities) do
            if entity.Name() == 'snail' and entity:collides(msg) then
                gSounds['kill']:play()
                gSounds['kill2']:play()
                msg.score = msg.score + 100
                table.remove(self.game_level.entities, k)
            end
        end
    end
end