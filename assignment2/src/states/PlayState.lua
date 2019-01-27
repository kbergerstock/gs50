--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly baseAppState gRSC
-- luacheck: globals renderHealth renderScore detect_and_handle_brick_collisions

PlayState = Class{__includes = baseAppState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(msg)
    self.inputs:reset()
    self.paused = false
    gRSC.sounds['music']:stop()
    -- give default ball random starting velocity
    msg.balls:startVelocity()
    msg.powerUps:setActive(8)
    msg.powerUps:setActive(9)
    if msg.level > 5 then
        msg.powerUps:setActive(7)
    end
    if msg.health < 2  then
        msg.powerUps:setActive(3)
    end
    if msg.keyBrickFlag and not msg.keyCaught then
        msg.powerUps:setActive(10)
    end
end

function PlayState:handleInput(input, msg)
    if input == 'p' or input == 'P' then
        self.paused = not self.paused
        gRSC.sounds['pause']:play()
    end
end

function PlayState:update(msg, dt)
    -- return a nil value !!! if paused
    if self.paused then
        return
    end
    -- update positions based on velocity
    msg.paddle:update(self.inputs, dt)
    msg.balls:update(dt)
    msg.powerUps:update(dt,msg)

    -- detect and handle ball collisions with the paddle
    msg.balls:handleCollisions(msg.paddle)

    -- detect collision across all bricks with the ball
    -- go to our victory screen if there are no more bricks left
    -- detect Brick Collision returns true if all the bricks are gone
    if detect_and_handle_brick_collisions(msg) then
        gRSC.sounds['victory']:play()
        msg.Change('victory')
   end

    -- if all balls are below bounds, revert to serve state and decrease health
    -- any active returns true if a ball is still in play otherwise false
    if  not msg.balls:anyActive() then
        msg.health = msg.health - 1
        gRSC.sounds['hurt']:play()

        if msg.health > 0 then
            msg.Change('serve')
        else
            msg.Change('game_over')
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(msg.bricks) do
        brick:update(dt)
    end
end

function PlayState:exit()
    gRSC.sounds['music']:play()
end

function PlayState:render(msg)
    -- render bricks
    for k, brick in pairs(msg.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(msg.bricks) do
        brick:renderParticles()
    end

    msg.paddle:render()
    msg.balls:render()
    msg.powerUps:render()

    renderScore(msg.score)
    renderHealth(msg.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gRSC.fonts['large'])
        love.graphics.printf("PAUSED", 0, self.VH / 2 - 16, self.VW, 'center')
    end
end