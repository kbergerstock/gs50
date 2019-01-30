--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState gRC

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.backgroundX = 0
    self.zt = 0
    self.fgCanvas = love.graphics.newCanvas(1600,160)
    self.bgCanvas = love.graphics.newCanvas(512,160)
end

function PlayState:enter(msg)
    math.randomseed(os.time())
    for i = 1, math.random(1000,1500) do
        math.random(100)
    end

    self.tile_map =  generateTileMap(100,10)

    self:updateFGcanvas()
    self.updateBGcanvas()
end

function PlayState:updateFGcanvas()
    love.graphics.setCanvas(self.fgCanvas)
    love.graphics.clear(0,0,0,0)
    self.tile_map:renderTiles()
    love.graphics.setCanvas()
end

function PlayState:updateBGcanvas()
    local background = math.random(3)
    love.graphics.setCanvas(self.bgCanvas)
    love.graphics.clear(0,0,0,0)
    
    love.graphics.setCanvas()
end

function PlayState:update(msg, dt)
    self:updateFGcanvas()
end

function PlayState:render(gameMsg)
    local bkgnds = 'backgrounds'

    -- render score
    local function renderScore(score)
        local ssx = 5
        local ssy = 5
        local d = 1000000
        local q = 0
        local r = score
        for i = 1, 6 do
            q, r = mod2 (r, d)
            d = d / 10
            love.graphics.draw(gRC.textures['numbers'],gRC.frames['numbers'][q+1],ssx,ssy)
            ssx = ssx + 10
        end
        love.graphics.draw(gRC.textures['numbers'],gRC.frames['numbers'][r+1],ssx,ssy)
    end

    local function gSX(u)
        return math.floor(-self.backgroundX + u)
    end
    local function gSY()
        return gRC.textures[bkgnds]:getHeight() / 3 * 2
    end

    love.graphics.push()
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][self.background], gSX(0), 0)
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][self.background], gSX(0), gSY(),0, 1, -1)
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][self.background], gSX(256), 0)
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][self.background], gSX(256), gSY(), 0, 1, -1)

    local quad = love.graphics.newQuad(16 + self.pos, 0, 256,160,1600,160)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas,quad)
    love.graphics.pop()
end
