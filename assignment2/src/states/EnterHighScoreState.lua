 --[[
    GD50
    Breakout Remake

    -- EnterHighScoreState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Screen that allows us to input a new high score in the form of three characters, arcade-style.
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly baseAppState
-- luacheck: globals gRSC.sounds gRSC.textures gRSC.frames gRSC.fonts CONST

EnterHighScoreState = Class{__includes = baseAppState}

-- individual chars of our string
local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

-- char we're currently changing
local highlightedChar = 1
local hilite = 103.0 / 255.0

function EnterHighScoreState:handleInput(input, msg)
    -- scroll through character slots
    if input == 'left' and highlightedChar > 1 then
        highlightedChar = highlightedChar - 1
        gRSC.sounds['select']:play()
    elseif input == 'right' and highlightedChar < 3 then
        highlightedChar = highlightedChar + 1
        gRSC.sounds['select']:play()
    -- scroll through characters
    elseif input == 'up' then
        chars[highlightedChar] = chars[highlightedChar] + 1
        if chars[highlightedChar] > 90 then
            chars[highlightedChar] = 65
        end
    elseif input == 'down' then
        chars[highlightedChar] = chars[highlightedChar] - 1
        if chars[highlightedChar] < 65 then
            chars[highlightedChar] = 90
        end
    elseif input == 'space' then
        -- update scores table
        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])
        msg.hsObj:add(name,msg.score)
        msg.hsObj:writeHighScores()
        msg.Change('high_scores')
    end
end

function EnterHighScoreState:render(msg)
    love.graphics.setFont(gRSC.fonts['medium'])
    love.graphics.printf('Your score: ' .. tostring(msg.score), 0, 30, self.VW, 'center')

    love.graphics.setFont(gRSC.fonts['large'])
    --
    -- render all three characters of the name
    --
    if highlightedChar == 1 then
        love.graphics.setColor(hilite,1,1,1)
    end
    love.graphics.print(string.char(chars[1]), self.VW/ 2 - 28, self.VH / 2)
    love.graphics.setColor(1,1,1,1)

    if highlightedChar == 2 then
        love.graphics.setColor(hilite,1,1,1)
    end
    love.graphics.print(string.char(chars[2]), self.VW/ 2 - 6, self.VH / 2)
    love.graphics.setColor(1,1,1,1)

    if highlightedChar == 3 then
        love.graphics.setColor(hilite,1,1,1)
    end
    love.graphics.print(string.char(chars[3]), self.VW/ 2 + 20, self.VH / 2)
    love.graphics.setColor(1,1,1,1)

    love.graphics.setFont(gRSC.fonts['small'])
    love.graphics.printf("Press Space or button 'b' to confirm!", 0, self.VH - 18, self.VW, 'center')
end