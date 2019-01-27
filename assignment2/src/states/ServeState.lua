--[[
    GD50
    Breakout Remake

    -- ServeState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The state in which we are waiting to serve the ball; here, we are
    basically just moving the paddle left and right with the ball until we
    press Enter, though everything in the actual game now should render in
    preparation for the serve, including our current health and score, as
    well as the level we're on.
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly baseAppState
-- luacheck: globals renderScore renderHealth gRSC LevelMaker Inputs

ServeState = Class{__includes = baseAppState}

function ServeState:enter(msg)
    self.inputs:reset()
    self:MakeLevel(msg)
    msg.paddle:reset()
    msg.balls:reset()
    msg.powerUps:reset()
end

function ServeState:MakeLevel(msg)
    if msg.makeLevel  then
        msg.bricks, msg.keyBrickFlag  = LevelMaker.createMap(msg.level)
        msg.keyCaught = false
        msg.breakout = false
        msg.makeLevel = (msg.bricks == nil )
    end
end

function ServeState:update(msg, dt)
    -- have the ball track the player
    msg.paddle:update(self.inputs,dt)
    msg.balls:track(msg.paddle)
end

function ServeState:handleInput(input, msg)
    if input == 'space' then
        if msg.makeLevel then
            self:MakeLevel(msg)
        else
            -- pass in all important state info to the PlayState
            msg.Change('play')
        end
     end
end

function ServeState:render(msg)
    msg.paddle:render()
    msg.balls:render()
    msg.powerUps:render()

    if msg.makeLevel then
        love.graphics.setFont(gRSC.fonts['large'])
        love.graphics.printf('Level creation error press space again ', 0, self.VH / 3, self.VW, 'center')
    else
        for k, brick in pairs(msg.bricks) do
            brick:render()
        end
    end

    renderScore(msg.score)
    renderHealth(msg.health)

    love.graphics.setFont(gRSC.fonts['large'])
    love.graphics.printf('Level ' .. tostring(msg.level), 0, self.VH / 3, self.VW, 'center')

    love.graphics.setFont(gRSC.fonts['medium'])
    love.graphics.printf("Press Space ot button 'b' to serve!", 0, self.VH / 2, self.VW, 'center')
end