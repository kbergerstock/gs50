--[[
    GD50
    Breakout Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between the sides
    of the world space, the player's paddle, and the bricks laid out above
    the paddle. The ball can have a skin, which is chosen at random, just
    for visual variety.
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState Target gRSC

Ball = Class{ __includes = Target}

function Ball:init(skin)
    -- flag to control if an instance is active
    self.active = false

    -- simple positional and dimensional variables
    self.width = 8
    self.height = 8

    self.x = gRSC.W.VIRTUAL_WIDTH / 2 - 2
    self.y = gRSC.W.VIRTUAL_HEIGHT / 2 - 2
    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0

    -- this will effectively be the color of our ball, and we will index
    -- our table of Quads relating to the global block texture using this
    self.skin = skin
end

function Ball:setActive()
    self.active = true
end

function Ball:clrActive()
    self.active = false
end

function Ball:isActive()
    return self.active
end

function Ball:beep()
    gRSC.sounds['wall-hit']:play()
end


function Ball:handleCollision(paddle)
    if self.active then
        -- raise ball above paddle in case it goes below it, then reverse dy
        self.y = paddle.y - 8
        self.dy = -self.dy

        -- tweak angle of bounce based on where it hits the paddle

        -- if we hit the paddle on its left side while moving left...
        if self.x < paddle.x + (paddle.width / 2) and paddle.dx < 0 then
            self.dx = -50 + -(8 * (paddle.x + (paddle.width / 2) - self.x))

        -- else if we hit the paddle on its right side while moving right...
        elseif self.x > paddle.x + (paddle.width / 2) and paddle.dx > 0 then
            self.dx = 50 + (8 * math.abs(paddle.x + paddle.width / 2 - self.x))
        end
    end
end

-- handle out of bounds condition
function Ball:checkBoundry()
    if self.y >= gRSC.W.VIRTUAL_HEIGHT then
        self.active = false
    end
end

--Places the ball in the middle of the screen, with no movement.
function Ball:reset(skin)
    if self.active then
        self.x = gRSC.W.VIRTUAL_WIDTH / 2 - 2
        self.y = gRSC.W.VIRTUAL_HEIGHT / 2 - 2
        self.dx = 0
        self.dy = 0
    end
    self.skin = skin
end

function Ball:update(dt)
    if self.active then
        local snd = false
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt

        -- allow ball to bounce off walls
        if self.x <= 0 then
            self.x = 0
            self.dx = -self.dx
            snd = true
        end

        if self.x >= gRSC.W.VIRTUAL_WIDTH - 8 then
            self.x = gRSC.W.VIRTUAL_WIDTH - 8
            self.dx = -self.dx
            snd = true
        end

        if self.y <= 0 then
            self.y = 0
            self.dy = -self.dy
            snd = true
        end
        if snd then
           self:beep()
        end
        self:checkBoundry()
    end
end

function Ball:render()
    if self.active then
        -- gTexture is our global texture for all blocks
        -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
        love.graphics.draw(gRSC.textures['main'], gRSC.frames['balls'][self.skin], self.x, self.y)
    end
end

function Ball:setStartVelocity()
    self.dx = math.random(-200, 200)
    self.dy = math.random(-80, -60)
end

function Ball:startBall()
    self:setStartVelocity()
    self.x = 25 + math.random(0,382)
    self.y = 7
    self:setActive()
end