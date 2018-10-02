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
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts CONST

VictoryState = Class{__includes = BaseState}

function VictoryState:update(msgs ,dt)
    msgs.paddle:update(dt)

    -- have the ball track the player
    msgs.balls:track(msgs.paddle)
end

function VictoryState:handleInput(input, msgs)
    -- go to play screen if the player presses Enter
    if input == 'space' then
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
    love.graphics.printf("Level " .. tostring(msgs.level) .. " complete!",0 , self.VH / 4, self.VW, 'center')

    -- instructions text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Space to Advance Level !', 0, self.VH / 2,self.VW, 'center')
end