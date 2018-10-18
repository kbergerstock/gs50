--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts

PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(tile_map,objects,entities)
    self.map = tile_map
    self.objects = objects
    self.entities = entities
end

function PlayerIdleState:enter(msg)
    assert(msg.name()== 'Otarin','OOPS a non player entity is acessing a player state -> '..msg.name())
    msg.animate:Start(500,{1,2})
end

function PlayerIdleState:update(msg, dt)
    msg.direction = 0
    msg.animate:update()

    -- if love.keyboard.isDown('space') then
    --     self.nextState('player_jump')
    -- elseif love.keyboard.isDown('left') then
    --     msg.direction = -1
    --     self.nextState('player_walking')
    -- elseif love.keyboard.isDown('right') then
    --     msg.direction = 1
    --     self.nextState('player_walking')
    -- else
    --     -- idle if we're not pressing anything at all
    --     msg.direction = 0
    -- end


    -- -- check if we've collided with any entities and die if so
    -- for k, entity in pairs(self.level.entities) do
    --     if msg.name() ~= entity.name() and entity:collides(msg) then
    --         gSounds['death']:play()
    --         msg.nextState('player_died')
    --     end
    -- end
end

function PlayerIdleState:exit(msg)
    msg.animate:Stop()
end

function PlayerIdleState:render(msg)
    msg:render()
end