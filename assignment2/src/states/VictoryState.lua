--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state that the game is in when we've just completed a level.
    Very similar to the ServeState, except here we increment the level
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly baseAppState gRSC
-- luacheck: ignore renderHealth renderScore

VictoryState = Class{__includes = baseAppState}

function VictoryState:update(msg ,dt)
    msg.paddle:update(self.inputs, dt)

    -- have the ball track the player
    msg.balls:track(msg.paddle)
end

function VictoryState:handleInput(input, msg)
    -- go to play screen if the player presses Enter
    if input == 'space' then
        msg.level = msg.level + 1
        msg.makeLevel = true
        msg.Change('serve')
    end
end

function VictoryState:render(msg)
    msg.paddle:render()
    msg.balls:render()

    renderHealth(msg.health)
    renderScore(msg.score)

    -- level complete text
    love.graphics.setFont(gRSC.fonts['large'])
    love.graphics.printf("Level " .. tostring(msg.level) .. " complete!",0 , self.VH / 4, self.VW, 'center')

    -- instructions text
    love.graphics.setFont(gRSC.fonts['medium'])
    love.graphics.printf('Press Space to Advance Level !', 0, self.VH / 2,self.VW, 'center')
end