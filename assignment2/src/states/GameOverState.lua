--[[
    GD50
    Breakout Remake

    -- GameOverState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The state in which we've lost all of our health and get our score displayed to us. Should
    transition to the EnterHighScore state if we exceeded one of our stored high scores, else back
    to the StartState.
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:init()
  
end

function GameOverState:enter(msgs)
  
 end

function GameOverState:update(keysPressed, msgs, dt)
    if keysPressed:getSpace() then
        -- see if score is higher than any in the high scores table
        if msgs.hsObj:checkScore(msgs.score) then
            gSounds['high-score']:play()
            msgs.next = 'enter_name'
        else 
            msgs.next = 'start'
        end
    end
end

function GameOverState:render(msgs)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(msgs.score), 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Space!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
end