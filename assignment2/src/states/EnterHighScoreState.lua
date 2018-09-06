 --[[
    GD50
    Breakout Remake

    -- EnterHighScoreState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Screen that allows us to input a new high score in the form of three characters, arcade-style.
]]

EnterHighScoreState = Class{__includes = BaseState}

-- individual chars of our string
local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

-- char we're currently changing
local highlightedChar = 1
local hilite = 103.0 / 255.0

function EnterHighScoreState:init()

end

function EnterHighScoreState:enter(msgs)

end

function EnterHighScoreState:update(keysPressed, msgs, dt)

    -- scroll through character slots
    if keysPressed:get('left') and highlightedChar > 1 then
        highlightedChar = highlightedChar - 1
        gSounds['select']:play()
    elseif keysPressed:get('right') and highlightedChar < 3 then
        highlightedChar = highlightedChar + 1
        gSounds['select']:play()
    end

    -- scroll through characters
    if keysPressed:get('up') then
        chars[highlightedChar] = chars[highlightedChar] + 1
        if chars[highlightedChar] > 90 then
            chars[highlightedChar] = 65
        end
    elseif keysPressed:get('down') then
        chars[highlightedChar] = chars[highlightedChar] - 1
        if chars[highlightedChar] < 65 then
            chars[highlightedChar] = 90
        end
    end

    if keysPressed:getSpace() then
        -- update scores table
        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])
        msgs.hsObj:add(name,msgs.score)
        msgs.hsObj:writeHighScores()
        msgs.next = 'high_scores' 
    end
end

function EnterHighScoreState:render(msgs)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your score: ' .. tostring(msgs.score), 0, 30,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    
    --
    -- render all three characters of the name
    --
    if highlightedChar == 1 then
        love.graphics.setColor(hilite,1,1,1)
    end
    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 28, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1,1,1,1)

    if highlightedChar == 2 then
        love.graphics.setColor(hilite,1,1,1)
    end
    love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1,1,1,1)

    if highlightedChar == 3 then
        love.graphics.setColor(hilite,1,1,1)
    end
    love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1,1,1,1)
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Space to confirm!', 0, VIRTUAL_HEIGHT - 18,
        VIRTUAL_WIDTH, 'center')
end