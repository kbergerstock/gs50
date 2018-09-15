--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    - GameOverState Class-

    State that simply shows us our score when we finally lose.
]]

-- luacheck: allow_defined, no unused, globals Class setColor love BaseState
-- luacheck: ignore VIRTUAL_WIDTH VIRTUAL_HEIGHT WINDOW_WIDTH WINDOW_HEIGHT

GameOverState = Class{__includes = BaseState}

function GameOverState:init()

end

function GameOverState:enter(msg)

end

function GameOverState:handle_input(input, msg)
    -- switch to another state via one of the menu options
    if input == 'space' then
        msg.nextState('start')
    end
end

function GameOverState:render(msg)
    love.graphics.setFont(gFonts['large'])

    setColor(56, 56, 56, 234)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 64, 64, 128, 136, 4)

    setColor(99, 155, 255, 255)
    love.graphics.printf('GAME OVER', VIRTUAL_WIDTH / 2 - 64, 64, 128, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your Score: ' .. tostring(msg.score), VIRTUAL_WIDTH / 2 - 64, 140, 128, 'center')
    love.graphics.printf('Press Enter', VIRTUAL_WIDTH / 2 - 64, 180, 128, 'center')
end