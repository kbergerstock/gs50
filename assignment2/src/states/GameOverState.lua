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
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly baseAppState gRSC

GameOverState = Class{__includes = baseAppState}

function GameOverState:handleInput(input, msg)
    if input == 'space' then
        -- see if score is higher than any in the high scores table
        if msg.hsObj:checkScore(msg.score) then
            gRSC.sounds['high-score']:play()
            msg.Change('enter_name')
        else
            msg.Change('start')
        end
    end
end

function GameOverState:render(msg)
    love.graphics.setFont(gRSC.fonts['large'])
    love.graphics.printf('GAME OVER', 0, self.VH / 3, self.VW, 'center')
    love.graphics.setFont(gRSC.fonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(msg.score), 0, self.VH / 2, self.VW, 'center')
    love.graphics.printf("'Press bitton 'b' or Space!", 0, self.VH - self.VH / 4, self.VW, 'center')
end