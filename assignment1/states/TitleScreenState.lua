--[[
    TitleScreenState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.

    removed dependency on gStateMachine global variable   07/15/2018 KRB
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        r = {} 
        r['state'] = 'countdown'
        return r
    end
end

function TitleScreenState:render()
    -- simple UI code
    love.graphics.setFont(flappyFont)
    love.graphics.printf('FIFTY BIRD', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('PRESS ENTER', 0, 100, VIRTUAL_WIDTH, 'center')
end