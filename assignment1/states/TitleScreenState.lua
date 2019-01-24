--[[
    TitleScreenState Class

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.

    removed dependency on gStateMachine global variable   07/15/2018 KRB
]]

-- luacheck: allow_defined,no unused
-- luacheck: globals love Class BaseState
-- luacheck: globals WINDOW_WIDTH WINDOW_HEIGHT VIRTUAL_WIDTH VIRTUAL_HEIGHT

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:enter(msg)
    -- controls the background scrolling
    msg.scrolling = false
end

function TitleScreenState:handleInput(input,msg)
    -- transition to countdown when the space bar is pressed
    -- easier to explain to my gradchildren
    if input == 'space' then
        msg.nextState('countdown')
    end
end

function TitleScreenState:render(msg)
    -- simple UI code
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(msg.fonts['flappy'])
    love.graphics.printf('FIFTY BIRD', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.setFont(msg.fonts['medium'])
    love.graphics.printf('PRESS SPACE', 0, 100, VIRTUAL_WIDTH, 'center')
end
