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
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts CONST

GameOverState = Class{__includes = BaseState}

function GameOverState:handleInput(input, msgs)
    if input == 'space' then
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
    love.graphics.printf('GAME OVER', 0, self.VH / 3, self.VW, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(msgs.score), 0, self.VH / 2, self.VW, 'center')
    love.graphics.printf('Press Space!', 0, self.VH - self.VH / 4, self.VW, 'center')
end