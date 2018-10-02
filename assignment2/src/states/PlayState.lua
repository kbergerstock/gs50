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
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts CONST

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(msgs)
    self.paused = false
    gSounds['music']:stop()
    -- give default ball random starting velocity
    msgs.balls:startVelocity()
    msgs.powerUps:setActive(8)
    msgs.powerUps:setActive(9)
    if msgs.level > 5 then
        msgs.powerUps:setActive(7)
    end
    if msgs.health < 2  then
        msgs.powerUps:setActive(3)
    end
    if msgs.keyBrickFlag and not msgs.keyCaught then
        msgs.powerUps:setActive(10)
    end
end

function PlayState:handleInput(input, msgs)
    if input == 'space' then
        self.paused = not self.paused
        gSounds['pause']:play()
    end
end

function PlayState:update(msgs, dt)
    -- return a nil value !!! if paused
    if self.paused then
        return
    end
    -- update positions based on velocity
    msgs.paddle:update(dt)
    msgs.balls:update(dt)
    msgs.powerUps:update(dt,msgs)

    -- detect and handle ball collisions with the paddle
    msgs.balls:handleCollisions(msgs.paddle)

    -- detect collision across all bricks with the ball
    -- go to our victory screen if there are no more bricks left
    -- detect Brick Collision returns true if all the bricks are gone
    if detect_and_handle_brick_collisions(msgs) then
        gSounds['victory']:play()
        msgs.next = 'victory'
   end

    -- if all balls are below bounds, revert to serve state and decrease health
    -- any active returns true if a ball is still in play otherwise false
    if  not msgs.balls:anyActive() then
        msgs.health = msgs.health - 1
        gSounds['hurt']:play()

        if msgs.health > 0 then
            msgs.next = 'serve'
        else
            msgs.next = 'game_over'
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(msgs.bricks) do
        brick:update(dt)
    end
end

function PlayState:exit()
    gSounds['music']:play()
end

function PlayState:render(msgs)
    -- render bricks
    for k, brick in pairs(msgs.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(msgs.bricks) do
        brick:renderParticles()
    end

    msgs.paddle:render()
    msgs.balls:render()
    msgs.powerUps:render()

    renderScore(msgs.score)
    renderHealth(msgs.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, self.VH / 2 - 16, self.VW, 'center')
    end
end