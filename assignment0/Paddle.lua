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
    for data. In this sense, they're very similar to structs in C.
]]
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.sx = x
    self.sy = y
    self.width = width
    self.height = height
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
end

function Paddle:update(dt)
    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Paddle:track(ball)
    -- track the incoming ball and place the paddle in front of it
    -- it uses the Y component of the AABM
    -- if the paddle is not in front of the ball it sets up paddle.dy to move it there
    -- all we have to do is set the paddle rate and the normal update routine will move the paddle
    -- krb
    bh2 = ball.height / 2
    if self.y > ball.y + ball.height - bh2 or ball.y > self.y + self.height-bh2 then
        self.dy = sign(ball.y - self.y) * PADDLE_SPEED
    else 
        self.dy = 0
    end
end
--[[ refactored this chunk out of main improves code maintainability, readability,
     and encapsulation all code that can change a class attributes is now owned by the class
     krb ]]
function Paddle:move(up, down)
    if love.keyboard.isDown(up) then
        self.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown(down) then
        self.dy = PADDLE_SPEED
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


