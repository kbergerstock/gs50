-- luacheck: allow_defined, no unused
-- luacheck: globals Class o love setColor readOnly BaseState _PowerUp gRSC

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

--[[     class PowerUps   an array of powerups    ]]--
PowerUps = Class()

function PowerUps:init()
    self.powerUps = {}
    self.effects  = {}
    self.effects[1] = resetPaddleSize
    self.effects[2] = resetPaddleSpeed
    self.effects[3] = addLife
    self.effects[7] = multpleBalls
    self.effects[8] = setPaddleSize
    self.effects[9] = incPaddleSpeed
    self.effects[10] = setKeyCaught
end

--[[
    This function is specifically made to piece out the power ups from the
    sprite sheet.
]]
function PowerUps:generateQuads(atlas)
    local x = 0
    local y = 64 + 4 * 2 * 16
    for i = 1, 11 do
        self.powerUps[i] =  _PowerUp(love.graphics.newQuad(x, y, 16, 16, atlas:getDimensions()))
        x = x + 16
    end
end

function PowerUps:update(dt,msg)
    for i , powerup in pairs(self.powerUps) do
        powerup:update(dt)
        if powerup:collidesWith(msg.paddle) then
            powerup:handleCollision()
            self.effects[i](msg)
        end
    end
end

function PowerUps:render()
    for i , powerup in pairs(self.powerUps) do
        powerup:render()
    end
end

function PowerUps:draw(ndx,x,y)
    self.powerUps[ndx]:draw(x,y)
end

function PowerUps:reset()
    for i , powerup in pairs(self.powerUps) do
        powerup:reset()
    end
end

function PowerUps:setActive(ndx)
    self.powerUps[ndx].active = true
end

function PowerUps:clrActive(ndx)
    self.powerUps[ndx].active = false
end

-- following functions are in a jump table
-- use the corsponding i value to call the correct jump value
-- as retured by the pairs syntax in an itteritive for loop
--
function setPaddleSize(msg)
    if msg.paddle.size == 2 then
        msg.paddle:setSize(3)
        msg.powerUps:setActive(1)
        msg.powerUps:clrActive(8)
    end
end

function resetPaddleSize(msg)
    if msg.paddle.size == 3 then
        msg.paddle:setSize(2)
        msg.powerUps:setActive(8)
        msg.powerUps:clrActive(1)
    end
end

function incPaddleSpeed(msg)
    msg.paddle:incPaddleSpeed()
    msg.powerUps:setActive(2)
    msg.powerUps:clrActive(9)
end

function resetPaddleSpeed(msg)
    msg.paddle:resetPaddleSpeed()
    msg.powerUps:setActive(9)
    msg.powerUps:clrActive(2)
end

function addLife(msg)
    msg.health = math.min(msg.health + 1 , 3)
    msg.powerUps:clrActive(3)
end

function multpleBalls(msg)
    msg.balls:setMultipleBallsInplay()
    msg.powerUps:clrActive(7)
end

function setKeyCaught(msg)
    msg.keyCaught = true
    msg.powerUps:clrActive(10)
end
