-- luacheck: no unused, globals Class love gRC mod2
-- luacheck: ignore Canvas

Canvas = Class{}

function Canvas:init(map)
    self.w = map.pixel_width
    self.h = map.pixel_height
    self.bkgnd = map.background
    self.pos = 0
    self.map = map
    self.fgCanvas = love.graphics.newCanvas(self.w, self.h)
    self.bgCanvas = love.graphics.newCanvas(512, self.h)
    self.anCanvas = love.graphics.newCanvas(self.w, self.h)
end

function Canvas:updateBG(textures,frames)
    local bkgnds = 'backgrounds'
    local sy = textures[bkgnds]:getHeight() / 3 * 2
    love.graphics.setCanvas(self.bgCanvas)
    love.graphics.clear(0,0,0,0)
    love.graphics.draw(textures[bkgnds], frames[bkgnds][self.bkgnd], 0, 0)
    love.graphics.draw(textures[bkgnds], frames[bkgnds][self.bkgnd], 0, sy,0, 1, -1)
    love.graphics.draw(textures[bkgnds], frames[bkgnds][self.bkgnd], 256, 0)
    love.graphics.draw(textures[bkgnds], frames[bkgnds][self.bkgnd], 256, sy, 0, 1, -1)
    love.graphics.setCanvas()
end

function Canvas:updateFG()
    love.graphics.setCanvas(self.fgCanvas)
    love.graphics.clear(0,0,0,0)
    self.map:renderTiles()
    love.graphics.setCanvas()
end

function Canvas:updateSprites(sprites)
    love.graphics.setCanvas(self.anCanvas)
    love.graphics.clear(0,0,0,0)
    if sprites then
        for i, sprite in pairs(sprites) do
            assert(sprite,'sprite is nil')
            sprite:render()
        end
    end

    love.graphics.setCanvas()
end

-- allows both forwards and backwards scrolling
function Canvas:updatePos(dir)
    self.pos = self.pos + dir
    if self.pos < 0 then
        self.pos = 0
    end
    if self.pos > (self.w - 256) then
        self.pos = self.w - 256
    end
end
-- allows scanvas to only move from the right to the left
function Canvas:updateRLpos(dir)
    if dir == 1 then
        self.pos = self.pos + dir
        if self.pos > (self.w - 256) then
            self.pos = self.w - 256
        end
    end
end

function Canvas:render()
    local q, r = mod2(self.pos/2, 256)
    local bgQuad = love.graphics.newQuad(r, 0, 256, self.h, 512, self.h )
    local fgQuad = love.graphics.newQuad(self.pos, 0, 256,self.h, self.w, self.h)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.bgCanvas, bgQuad)
    love.graphics.draw(self.fgCanvas, fgQuad)
    love.graphics.draw(self.anCanvas, fgQuad)
end