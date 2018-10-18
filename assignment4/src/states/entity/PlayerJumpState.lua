--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts gCT

PlayerJumpState = Class{__includes = BaseState}

function PlayerJumpState:init(tile_map,objects,entities)
    self.map = tile_map
    self.objects = objects
    self.entities = entities
    self.animation = Animation {
        frames = {3},
        interval = 1
    }
end

-- the player IS the message packet
function PlayerJumpState:enter(msg)
    assert(msg.name()== 'Otarin','OOPS a none player is acessing a player state -> '..msg.name())
    msg.currentFrame = self.animation:getCurrentFrame()
    gSounds['jump']:play()
    msg.dy = gCT.PLAYER_JUMP_VELOCITY
end

function PlayerJumpState:update(msg, dt)
    msg.currentFrame = animation:getCurrentFrame()
    msg.dy = msg.dy + msg.gravity
    msg.y = msg.y + (msg.dy * dt)
    -- should an x compment be included -- NOTE

    -- go into the falling state when y velocity is positive
    if msg.dy >= 0 then
        msg.changeState('player_falling')
    end

    -- look at two tiles above our head and check for collisions; 3 pixels of leeway for getting through gaps
    local tile1 = msg.map:pointToTile(msg.x + msg.direction * 3, msg.y)
    local tile2 = msg.map:pointToTile(msg.x + msg.directioin * (msg.width + 3), msg.y)

    -- if we get a collision up top, go into the falling state immediately
    if (tile1 and tile2) and (tile1:collidable() or tile2:collidable()) then
        msg.dy = 0
        msg.changeState('playing_falling')
    else
        -- else test our sides for blocks
        if love.keyboard.isDown('left') then
            msg.direction = -1
        elseif love.keyboard.isDown('right') then
            msg.direction = 1
        else
            msg.direction = 0
        end
        msg.checkCollisions(self.game_level, dt)
    end

    -- check if we've collided with any collidable game objects
    for k, object in pairs(self.game_level.objects) do
        if object:collides(msg) then
            if object.solid then
                object.onCollide(object)

                msg.y = object.y + object.height
                msg.dy = 0
                msg.nextState('falling')
            elseif object.consumable then
                object.onConsume(msg)
                table.remove(self.game_level.objects, k)
            end
        end
    end

    -- check if we've collided with any entities and die if so
    for k, entity in pairs(self.game_level.entities) do
        if entity.name() ~= 'Otarin' and entity:collides(msg) then
            gSounds['death']:play()
            msg.nextState('player_dead')
        end
    end
end