--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Message StateMachine Class setColor love
-- luacheck: globals gFonts gTextures gFrames gSounds gCT

Tile = Class{}

function Tile:init(x, y, id, topper, tileset, topperset)
    self.size = gCT.TILE_SIZE
    self.tx = x
    self.ty = y
    self.sx = (self.tx - 1) * self.size
    self.sy = (10 - self.ty) * self.size

    self.width = size
    self.height = size

    self.id = id
    self.tileset = tileset
    self.topper = topper
    self.topperset = topperset
end

function Tile:render()
    love.graphics.draw(gTextures['tiles'], gFrames['tilesets'][self.tileset][self.id],self.sx,self.sy)
    -- tile top layer for graphical variety
    if self.topper then
        love.graphics.draw(gTextures['toppers'], gFrames['toppersets'][self.topperset][self.id],self.sx,self.sy)
    end
end