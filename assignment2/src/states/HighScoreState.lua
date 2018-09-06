--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the screen where we can view all high scores previously recorded.
]]

HighScoreState = Class{__includes = BaseState}

function HighScoreState:init()

end

function HighScoreState:enter(msgs)
        
end

function HighScoreState:update(keysPressed, msgs, dt)
    assert(not(keysPressed == nil),'illeagl parameter')
    -- return to the start screen if we press escape
    if keysPressed:getSpace() then
        gSounds['wall-hit']:play()
        msg.next = 'start'
    end
end

function HighScoreState:render(msgs)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])

    local hst = msgs.hsObj:get()
    -- iterate over all high score indices in our high scores table
    for i = 1, hst.count do
        local name = hst[i].name or '---'
        local score = hst[i].score or '---'

        -- score number (1-10)
        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4, 
            60 + i * 13, 50, 'left')

        -- score name
        love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 38, 
            60 + i * 13, 50, 'right')
        
        -- score itself
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2,
            60 + i * 13, 100, 'right')
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press Space to return to the main menu!",
        0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end
