--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Message StateMachine cHID Class setColor love
-- luacheck: globals gFonts gTextures gFrames gSounds CONST COLLIDABLE_TILES

Tile = Class{}

function Tile:init(x, y, id, topper, tileset, topperset)
    self.x = x
    self.y = y
    self.sx = (x-1) * CONST.TILE_SIZE
    self.sy = (y-1) * CONST.TILE_SIZE

    self.width = CONST.TILE_SIZE
    self.height = CONST.TILE_SIZE

    self.id = id
    self.tileset = tileset
    self.topper = topper
    self.topperset = topperset
end

--[[
    Checks to see whether this ID is whitelisted as collidable in a global constants table.
]]
function Tile:collidable(target)
    for k, v in pairs(COLLIDABLE_TILES) do
        if v == self.id then
            return true
        end
    end

    return false
end

function Tile:render()
    love.graphics.draw(gTextures['tiles'], gFrames['tilesets'][self.tileset][self.id],self.sx, self.sy)
    -- tile top layer for graphical variety
    if self.topper then
        love.graphics.draw(gTextures['toppers'], gFrames['toppersets'][self.topperset][self.id],self.sx,self.sy)
    end
end