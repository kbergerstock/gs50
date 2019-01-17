--[[
    GD50 2018
    Pong Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.

    refactored by K. r. bergerstock (krbergerstock@e4kountdown.com)
    added vatiables
        score : it makes more sense to track the score by player object
        sx,sy : home position for paddle
    added functions
        resetScore()
        incScore()
        Won()
        resetPos()
        track(ball)  : AI addition
        move(up,down): code reductiom

]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love Paddle sign
-- luacheck: globals VIRTUAL_WIDTH VIRTUAL_HEIGHT PADDLE_SPEED

-- paddle movement speed
PADDLE_SPEED = 200

Paddle = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.#ll#
]]
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.sx = x
    self.sy = y
    self.width = width
    self.height = height
    self.h2 = height / 2
    self.dy = 0
    self.score = 0
end

function Paddle:resetScore()
    self.score = 0
end

function Paddle:incScore()
    self.score = self.score + 1
end

function Paddle:Won()
    if self.score >= 10 then
        return true
    else
        return false
    end
end

function Paddle:resetPos()
    self.x = self.sx
    self.y = self.sy
    self.dy = 0
end

function Paddle:update(dt)
    self.y = self.y + self.dy * PADDLE_SPEED * dt
    -- bounds check y position
    if self.y < 0  then
        self.y = 0
    elseif self.y > (VIRTUAL_HEIGHT - self.height) then
        self.y = VIRTUAL_HEIGHT - self.height
    end
end

function Paddle:track(ball)
    -- track the incoming ball and calculate the next itertation of the controll pid
    -- it uses the Y component of the AABM
    -- krb
    local err = (ball.y + 2) - (self.y + self.h2 )
    self.dy = sign(err)
    if self.dy * err < 2 then
        self.dy = 0
    end
end

--[[ refactored this chunk out of main improves code maintainability, readability,
     and encapsulation all code that can change a class attributes is now owned by the class
     krb ]]
function Paddle:move(up, down)
    if love.keyboard.isDown(up) then
        self.dy = -1
    elseif love.keyboard.isDown(down) then
        self.dy = 1
    else
        self.dy = 0
    end
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end


