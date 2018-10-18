--[[
    GD50
    Super Mario Bros. Remake

    -- TileMap Class --
]]

require 'lib/mod'

-- luacheck: no unused, globals Class gCT mod2 love
-- luacheck: ignore TileMap

TileMap = Class{}

function TileMap:init(def)
    -- width and height are in number of tiles
    self.width = def._width
    self.height = def._height
    self.tiles = def._tiles
    self.objects = def._objects
    assert(self.objects,"no objects to render")
    -- _width, _height and tile_size are in pixels
end

-- retrieve a tile given the col, row coordinates of a tile
-- this function uses the 1 based index forumla
function TileMap:getTile(tx, ty)
    local ndx = (ty - 1) * self.width  + tx
    return self.tiles[ndx]
end

function TileMap:renderTiles()
    for k ,tile in pairs(self.tiles) do
        tile:render()
    end
end

function TileMap:renderObjects()
    assert(self.objects,"no objects to render")
    for k, object in pairs(self.objects) do
        object:render()
    end
end

function TileMap:update(direction)
end
