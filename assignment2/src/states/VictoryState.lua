--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state that the game is in when we've just completed a level.
    Very similar to the ServeState, except here we increment the level 
]]

VictoryState = Class{__includes = BaseState}

function VictoryState:update(keysPressed, msgs ,dt)
    msgs.paddle:update(dt)

    -- have the ball track the player
    msgs.balls:track(msgs.paddle)

    -- go to play screen if the player presses Enter
    if keysPressed:getSpace() then
        msgs.level = msgs.level + 1 
        msgs.makeLevel = true 
        msgs.next = 'serve'
    end
end

function VictoryState:render(msgs)
    msgs.paddle:render()
    msgs.balls:render()

    renderHealth(msgs.health)
    renderScore(msgs.score)

    -- level complete text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(msgs.level) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Space to Advance Level !', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end