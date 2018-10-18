--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Message StateMachine Class setColor love BaseState
-- luacheck: globals gFonts gTextures gFrames gSounds

StartState = Class{__includes = BaseState}

function StartState:enter(msg)
    self.tile_map = generateTileMap(100,10)
    self.game_pad = GamePad()
    self.background = math.random(3)
end

function StartState:handle_input(input,msg)
    if input == 'space' then
        msg.nextState('play')
    end
end

function StartState:render(msg)
    local bh = gTextures['backgrounds']:getHeight() / 3 * 2
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0, 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0, bh, 0, 1, -1)
    self.tile_map:renderTiles()
    self.tile_map:renderObjects()
    love.graphics.pop()

    love.graphics.setFont(gFonts['title'])
    setColor(0, 0, 0, 255)
    love.graphics.printf("Otarin's Run", 1, 6, self.VW, 'center')
    setColor(06, 96, 255, 255)
    love.graphics.printf("Otarin's Run", 0, 5, self.VW, 'center')

    love.graphics.setFont(gFonts['medium'])
    setColor(0, 0, 0, 255)
    love.graphics.printf('Press Space', 1, 31 , self.VW, 'center')
    setColor(255, 255, 255, 255)
    love.graphics.printf('Press Space', 0, 30 , self.VW, 'center')
    local gpr = self.game_pad:input()
    if gpr and gpr.buttanA then
        msg.nextState('play')
    end
end