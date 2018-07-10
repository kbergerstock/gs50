--[[
    GD50 2018
    Pong Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.

    refactored by K. r. bergerstock (krbergerstock@e4kountdown.com)
    added functions
        handleBallCollision
        handleServe
        handleWallCollision
            improving encapsulatoin and readability
        added global function sign(d) needed for A! task
]]

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles overlap.
]]
function Ball:collides(paddle)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 
    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

--[[
    handles the collision with a paddle
    input is the offset to use to avoid getting stuck in paddle
    krb
]]
function Ball:handlePaddleCollision(offset)
    self.dx = -self.dx * 1.03
    self.x = offset
    -- keep velocity going in the same direction, but randomize it
    self.dy = sign(self.dy) * math.random(10, 150)
end

-- handle the ball serve
-- krb
function Ball:handleServe(player)
    -- before switching to play, initialize ball's velocity based
    -- on player who last scored
    self.dy = math.random(-50, 50)
    if player == 1 then dd = 1 else dd = -1 end
    self.dx = dd * math.random(140, 200)   
end

-- handle a wall collision
-- detect upper and lower screen boundary collision, playing a sound
-- effect and reversing dy if true
-- krb
function Ball:handleWallCollision()
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
        return true
    end
    if ball.y >= VIRTUAL_HEIGHT - self.height then
        ball.y = VIRTUAL_HEIGHT - self.height
        ball.dy = -ball.dy
        return true
    end
    return false    
end    

-- returns the sign function of a number
function sign(d)
    if d < 0 then
        return -1
    elseif d == 0 then
        return 0
    else  
        return 1
    end    
end