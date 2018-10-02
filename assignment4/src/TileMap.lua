--[[
    GD50
    Super Mario Bros. Remake

    -- TileMap Class --
]]

require 'lib/mod'

-- luacheck: no unused, globals Class CONST mod2
-- luacheck: ignore TileMap

TileMap = Class{}

function TileMap:init(width, height, tiles)
    self.width = width
    self.height = height
    self._width = width * CONST.TILE_SIZE
    self._height = height * CONST.TILE_SIZE
    self.tile_size  = CONST.TILE_SIZE
    self.tiles = tiles
end

--[[
    If our tiles were animated, this is potentially where we could iterate over all of them
    and update either per-tile or per-map animations for appropriately flagged tiles!
]]
function TileMap:update(dt)

end

--[[
    Returns the x, y of a tile given an x, y of coordinates in the world space.
]]
function TileMap:pointToTile(x, y)
    if x < 0 or x > self._width  or y < 0 or y > self._height then
        return nil
    end
    -- since these are zero bzsed the ndx formula changes
    local tx = mod2(x,self.tile_size)
    local ty = mod2(y,self.tile_size)
    local ndx = x * self.height + y + 1
    return self.tiles[ndx]
end

function TileMap:render()
    for ndx,tile in pairs(self.tiles) do
        tile:render()
    end
end