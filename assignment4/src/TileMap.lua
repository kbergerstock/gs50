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
    self.tile_size  = def.tile_size
    self.display_width = 18
    self.display_height = 10
    -- origin of map to be displayed
    self.origin_x = 0
end

-- retrieve a tile given the col, row coordinates of a tile
-- this function uses the 1 based index forumla
function TileMap:getTile(tx, ty)
    local ndx = (ty - 1) * self.width  + tx
    return self.tiles[ndx]
end

function TileMap:renderTiles()
    for k ,tile in pairs(self.tiles) do
        if self.origin_x < tile.tx and tile.tx <= self.origin_x + self.display_width then
            tile:render(self.origin_x)
        end
    end
end

function TileMap:renderObjects()
    assert(self.objects,"no objects to render")
    for k, object in pairs(self.objects) do
        if self.origin_x < object.tx and object.tx <= self.origin_x + self.display_width then
            object:render(self.origin_x)
        end
    end
end

function TileMap:update(direction)
    self.origin_x = self.origin_x + direction
    if self.origin_x < 0 then self.origin_x = 0 end
    if self.origin_x > self.width - self.display_width then
        self.origin_x = self.width - self.display_width
    end
end

function TileMap:renderCanvas(quad)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas,quad)
end