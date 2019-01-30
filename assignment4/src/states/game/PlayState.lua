--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor BaseState gRC Inputs mod2
-- luacheck: globals generateTileMap

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.inputs = Inputs()
    self.pos = 0
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
    self:updateBGcanvas()
end

function PlayState:updateFGcanvas()
    love.graphics.setCanvas(self.fgCanvas)
    love.graphics.clear(0,0,0,0)
    self.tile_map:renderTiles()
    love.graphics.setCanvas()
end

function PlayState:updateBGcanvas()
    local bkgnd = math.random(3)
    local bkgnds = 'backgrounds'
    local sy = gRC.textures[bkgnds]:getHeight() / 3 * 2
    love.graphics.setCanvas(self.bgCanvas)
    love.graphics.clear(0,0,0,0)
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][bkgnd], 0, 0)
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][bkgnd], 0, sy,0, 1, -1)
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][bkgnd], 256, 0)
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][bkgnd], 256, sy, 0, 1, -1)
    love.graphics.setCanvas()
end

function PlayState:handleInputs(input, msg)
    if input == 'left' or input == 'GPleft' then
            self.pos = self.pos - 1
        elseif input == 'right' or input == 'GPright' then
            self.pos = self.pos + 1
        else
            self.inputs:set(input)
        end
end

function PlayState:updatePos()
    if self.pos < 0 then
        self.pos = 0
    end
    if self.pos > (1600 - 256) then
        self.pos = 1600 - 256
    end
end

function PlayState:update(msg, dt)
    self:updatePos()
    self:updateFGcanvas()
    self.inputs:reset()
end

function PlayState:render(msg)
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

    local q, r = mod2(16 + self.pos, 256)
    love.graphics.push()
    local bgQuad = love.graphics.newQuad(r, 0, 256, 160, 512, 160)
    local fgQuad = love.graphics.newQuad(16 + self.pos, 0, 256,160,1600,160)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.bgCanvas, bgQuad)
    love.graphics.draw(self.fgCanvas, fgQuad)
    renderScore(msg.score)
    love.graphics.pop()
end

