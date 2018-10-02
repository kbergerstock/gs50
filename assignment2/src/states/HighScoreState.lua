--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the screen where we can view all high scores previously recorded.
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts CONST

HighScoreState = Class{__includes = BaseState}

function HighScoreState:handleInput(input, msgs)
    -- return to the start screen if we press escape
    if input == 'space' then
        gSounds['wall-hit']:play()
        msgs.next = 'start'
    end
end

function HighScoreState:render(msgs)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('High Scores', 0, 20, self.VW, 'center')

    love.graphics.setFont(gFonts['medium'])

    local hst = msgs.hsObj:get()
    -- iterate over all high score indices in our high scores table
    for i = 1, hst.count do
        local name = hst[i].name or '---'
        local score = hst[i].score or '---'
        local y = 60 + i * 13
        -- score number (1-10)
        love.graphics.printf(tostring(i) .. '.', self.VW / 4, y, 50, 'left')
        -- score name
        love.graphics.printf(name, self.VW / 4 + 38, y, 50, 'right')
        -- score itself
        love.graphics.printf(tostring(score), self.VW / 2, y, 100, 'right')
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press Space to return to the main menu!", 0, self.VH - 18, self.VW, 'center')
end
