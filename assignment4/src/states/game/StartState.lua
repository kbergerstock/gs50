--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Message StateMachine cHID Class setColor love BaseState
-- luacheck: globals VIRTUAL_WIDTH VIRTUAL_HEIGHT
-- luacheck: globals gFonts gTextures gFrames gSounds LevelMaker

StartState = Class{__includes = BaseState}

function StartState:enter(msg)
    self.map = GenerateLevel(100, 10)
    self.background = math.random(3)
end


function StartState:handle_input(input,msg)
    if input == 'space' then
        msg:nextState('play')
    end
end

function StartState:render(msg)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0, 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0,
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    self.map:render()

    love.graphics.setFont(gFonts['title'])
    setColor(0, 0, 0, 255)
    love.graphics.printf('Super 50 Bros.', 1, 11, VIRTUAL_WIDTH, 'center')
    setColor(255, 255, 255, 255)
    love.graphics.printf('Super 50 Bros.', 0, 10, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    setColor(0, 0, 0, 255)
    love.graphics.printf('Press Space', 1, 41 , VIRTUAL_WIDTH, 'center')
    setColor(255, 255, 255, 255)
    love.graphics.printf('Press Space', 0, 40 , VIRTUAL_WIDTH, 'center')
end