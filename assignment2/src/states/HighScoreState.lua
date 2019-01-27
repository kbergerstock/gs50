--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the screen where we can view all high scores previously recorded.
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly baseAppState gRSC

HighScoreState = Class{__includes = baseAppState}

function HighScoreState:handleInput(input, msg)
    -- return to the start screen if we press escape
    if input == 'space' then
        gRSC.sounds['wall-hit']:play()
        msg.Change('start')
    end
end

function HighScoreState:render(msg)
    love.graphics.setFont(gRSC.fonts['large'])
    love.graphics.printf('High Scores', 0, 20, self.VW, 'center')

    love.graphics.setFont(gRSC.fonts['medium'])

    local hst = msg.hsObj:get()
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

    love.graphics.setFont(gRSC.fonts['small'])
    love.graphics.printf("Press Space or button 'b' to return to the main menu!", 0, self.VH - 18, self.VW, 'center')
end
