-- powerUp class
-- krbergerstock

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

_PowerUp = Class{__includes = Target}

function _PowerUp:reset()
    self.drop = math.random(7.0,45.0)
    self.accum = 0
    self.gravity = 0
    self.x = 0
    self.y = 0
    self.visible = false
    self.active = false 
    self.height = 16
    self.width = 16
    self.dy = 0
    self.dx = 0
end

function _PowerUp:init(quad)
    self.quad = quad
    self:reset()
end

function _PowerUp:handleCollision()
    self.visible = false
    self.drop = math.random(5.0, 55.0)
    self.accum = 0
end

function _PowerUp:update(dt)
    if self.active then
        if self.visible then
            self.dy = self.dy + self.gravity * dt
            self.y = self.y + self.dy
            if self.y > VIRTUAL_HEIGHT then
                self:handleCollision()
            end
        else
            self.accum = self.accum + dt
            if self.accum > self.drop then
                self.visible = true 
                self.x = math.random(32, VIRTUAL_WIDTH - 32)
                self.y = 8
                self.dy = 1      
                self.gravity = math.random(0.5,1.5)
            end
        end
    end
end

-- returns true if powerup collies with the paddle  otherwise false
function _PowerUp:collidesWith(paddle)
    if self.active and self.visible then
        return self:collides(paddle) 
    end     
    return false 
end

function _PowerUp:render()
    if self.active and self.visible then
        love.graphics.draw(gTextures['main'],self.quad,self.x,self.y)
    end
end

function _PowerUp:draw(x,y)
    love.graphics.draw(gTextures['main'],self.quad,x,y)
end
