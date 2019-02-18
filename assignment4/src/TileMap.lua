--[[
    GD50
    Super Mario Bros. Remake

    -- TileMap Class --
]]

require 'lib/mod'
require 'src/Tile'

-- luacheck: no unused, globals Class love
-- luacheck: ignore TileMap

TileMap = Class{}

function TileMap:init(level)
    -- width and height are in number of tiles
    self.pos    = 0
    self.width  = level.width
    self.height = level.height
    self.tiles  = level.tiles
    self.pixel_width = level:get_pixel_width()
    self.pixel_height = level:get_pixel_height()
    self.background = level:get_background()
end

-- retrieve a tile given the col, row coordinates of a tile
-- this function uses the 0 based index forumla
function TileMap:getTile(tx, ty)
    local ndx = ty * self.width  + tx + 1
    return self.tiles[ndx]
end

function TileMap:setTile(tx,ty,tile)
    tile.tx = tx
    tile.ty = ty
    local ndx = ty * self.width + tx + 1
    self.tiles[ndx]=tile
end

function TileMap:renderTiles()
    for k ,tile in pairs(self.tiles) do
       tile:render()
    end
end

function TileMap:getWidth()
    return self.width
end

function TileMap:getHeight()
    return self.height
end
