--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts gCT

PlayerWalkingState = Class{__includes = BaseState}

function PlayerWalkingState:init(tile_map, objects, entities)
    self.map = tile_map
    self.objects = objects
    self.entities = entities
    self.animation = Animation {
        frames = {10, 11},
        interval = 0.1
    }
end

function PlayerWalkingState:enter(msg)
    assert(msg.name() == 'Otarin','OOPS a non player entity is acessing a player state -> '..msg.name())
    msg.currentFrame = self.animation.getCurrentFrame()
end

function PlayerWalkingState:update(msg, dt)
    self.animation:update(dt)
    msg.currentFrame = self.animation:getCurrentFrame()

    if love.keyboard.isDown('space') then
        msg.nextState('player_jump')
    elseif love.keyboard.isDown('left') then
        msg.direction = -1
    elseif love.keyboard.isDown('right') then
        msg.direction = 1
    else
        -- idle if we're not pressing anything at all
        msg.direction = 0
        msg.nextState('player_idle')
    end

    if msg.direction ~= 0 then
        local tile1 = msg.map:pointToTile(msg.x + msg.direction, msg.y + msg.height)
        local tile2 = msg.map:pointToTile(msg.x + msg.direction * (msg.width + 1), msg.y + msg.height)

        -- temporarily shift player down a pixel to test for game objects beneath
        msg.y = msg.y + 1

        local collidedObjects = msg.checkObjectCollisions()

        msg.y = msg.y - 1
        -- (not exp1 and not exp2) is equivelent to not(exp1 or exp2)
        -- check to see whether there are any tiles beneath us
        if #collidedObjects == 0 and (tile1 and tile2) and not(tile1:collidable() or tile2:collidable()) then
            msg.dy = 0
            msg.nextState('player_falling')
        else
            msg.x = msg.x + msg.direction * gCT.PLAYER_WALK_SPEED * dt
            msg.checkCollisions(self.game_level, dt)
        end
      end

    -- check if we've collided with any entities and die if so
    for k, entity in pairs(self.game_level.entities) do
        if entity:collides(msg) then
            gSounds['death']:play()
            msg.nextState('player_dead')
        end
    end
end