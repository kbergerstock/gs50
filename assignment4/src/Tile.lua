--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Message StateMachine Class setColor love gRC


Tile = Class{}

function Tile:init(x, y, id, topper, tileset, topperset)
    self.size =  gRC.TILE_SIZE
    self.tx = x - 1
    self.ty = y - 1
    self.mx = self.tx  * self.size
    self.my = self.ty  * self.size

    self.width = self.size
    self.height = self.size

    self.id = id
    self.tileset = tileset
    self.topper = topper
    self.topperset = topperset
end

function Tile:render()
    local sx = self.mx
    local sy = 146 - self.my
    love.graphics.draw(gRC.textures['tiles'], gRC.frames['tilesets'][self.tileset][self.id],sx,sy)
    -- tile top layer for graphical variety
    if self.topper then
        love.graphics.draw(gRC.textures['toppers'], gRC.frames['toppersets'][self.topperset][self.id],sx,sy)
    end
end