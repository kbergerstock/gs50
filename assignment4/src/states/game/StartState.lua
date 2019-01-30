--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Message StateMachine Class setColor love BaseState
-- luacheck: globals gRC generateTileMap

StartState = Class{__includes = BaseState}

function StartState:enter(msg)
    self.tile_map = generateTileMap(100,10)
    self.background = math.random(3)
end

function StartState:handleInput(input, msg)
    if input == 'space' or input == 'GPb' then
        msg.Change('play')
    end
end

function StartState:render(msg)
    local bh = gRC.textures['backgrounds']:getHeight() / 3 * 2
    love.graphics.push()
    love.graphics.draw(gRC.textures['backgrounds'], gRC.frames['backgrounds'][self.background], 0, 0)
    love.graphics.draw(gRC.textures['backgrounds'], gRC.frames['backgrounds'][self.background], 0, bh, 0, 1, -1)
    self.tile_map:renderTiles()
    self.tile_map:renderObjects()
    love.graphics.pop()

    local VW = gRC.VIRTUAL_WIDTH

    love.graphics.setFont(gRC.fonts['title'])
    setColor(0, 0, 0, 255)
    love.graphics.printf("Otarin's Run", 1, 6, VW, 'center')
    setColor(06, 96, 255, 255)
    love.graphics.printf("Otarin's Run", 0, 5, VW, 'center')

    love.graphics.setFont(gRC.fonts['medium'])
    setColor(0, 0, 0, 255)
    love.graphics.printf('Press Space', 1, 31 , VW, 'center')
    setColor(255, 255, 255, 255)
    love.graphics.printf('Press Space', 0, 30 , VW, 'center')
end