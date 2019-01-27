-- implements and controls an array of balls
-- to meet requirements for adding the feature of handling miltiple balls in play
-- @ k.r.bergerstock
-- 08/2018
-- class G50.cs

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState Ball Target gRSC

Balls = Class{}

-- constructor
function Balls:init()
    self.balls = {}
    self.balls[1] = Ball(1)
    self.balls[2] = Ball(2)
    self.balls[3] = Ball(3)
end

function Balls:reset()
    -- activate the default ball in play
    self.balls[1]:setActive()
    -- clear the rest
    self.balls[2]:clrActive()
    self.balls[3]:clrActive()
    -- give each ball a new skin
    for i , ball in pairs(self.balls) do
        ball:reset(math.random(7))
    end
end

function Balls:getList()
    return self.balls
end

function  Balls:track(paddle)
    self.balls[1].x = paddle.x + (paddle.width / 2) - 4
    self.balls[1].y = paddle.y - 8
end

function Balls:startVelocity()
    self.balls[1]:setStartVelocity()
end

function Balls:update(dt)
    for i , ball in pairs(self.balls) do
        ball:update(dt)
    end
end

function Balls:render()
    for i, ball in pairs(self.balls) do
        ball:render()
    end
end

function Balls:anyActive()
    for i , ball in pairs(self.balls) do
        if ball:isActive() then
            return true
        end
    end
    return false
end

function Balls:handleCollisions(paddle)
    for i , ball in pairs(self.balls) do
        if ball:collides(paddle) then
            ball:handleCollision(paddle)
            gRSC.sounds['paddle-hit']:play()
        end
    end
end

function Balls:setMultipleBallsInplay()
    for i, ball in pairs(self.balls) do
        if not ball:isActive() then
            ball:startBall()
        end
    end
end