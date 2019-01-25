--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]
-- luacheck: allow_defined,no unused
-- luacheck: globals love Class
-- luacheck: globals WINDOW_WIDTH WINDOW_HEIGHT VIRTUAL_WIDTH VIRTUAL_HEIGHT
-- luacheck: globals PIPE_SPEED PIPE_WIDTH PIPE_HEIGHT
-- luacheck: globals BIRD_WIDTH BIRD_HEIGHT COUNTDOWN_TIME

Bird = Class{}

local GRAVITY = {5.0, 3.0}
local ANTIGRAVITY = {-1.5, -0.75}
local mode = 0

function Bird:init()
    self.image = love.graphics.newImage('img/bird.png')
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = 0.0
end

--  reset the bird's position used when playstate is entered
function Bird:reset()
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8
    self.dy =  0.0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if pipe.orientation < 0 then -- top pipe
            if (self.y + 2) < pipe.y then return true end
        else                -- otherwise bottom pipe
            if (self.y - 2 + self.height ) > pipe.y then return true end
        end
    end
    return false
end

function Bird:update(msg, dt)
    -- burst of anti-gravity when user sends an 'up' command
    if msg.user:get('up') then
        self.dy = ANTIGRAVITY[mode]
        msg.sounds['jump']:play()
    else
        self.dy = self.dy + GRAVITY[mode] * dt
    end
    msg.user:reset()
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:setMode(key)
    if key == '2' then
        mode = 2
    else
        mode = 1
    end
end