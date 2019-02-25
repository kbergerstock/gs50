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
    self.width  = level.map_width       -- number of horizntal tiles in map
    self.height = level.map_height      -- number of vertical tiles  in map
    self.tiles  = level.tiles       -- array og tiles ie the virtual world
    self.tile_size = level.tile_size    -- size of tiles in pixels
    self.pixel_width = level:get_pixel_width()
    self.pixel_height = level:get_pixel_height()
    self.background = level.background   --  back drop to be displayed
    self.gravity = level.gravity         --   gravity constant to be used for level
end

-- given sx and sy find the tile location tx and ty
function TileMap:screen_to_tile(sx, sy)
    local r , tx , ty
    tx, r = mod2(sx, self.tile_size)
    ty, r = mod2(sy, self.tile_size)
    return tx, ty
end

-- retrieve a tile given the col, row coordinates of a tile
-- this function uses the 0 based index forumla
function TileMap:get_tile(tx, ty)
    if ty < 0 or tx  < 0 then
        local def = {}
        def.tx = 0
        def.ty = 0
        def.id = ID.EMPTY
        def.tile_size = 1
        return baseTile(def)
    else
        local ndx = ty * self.width  + tx + 1
        return self.tiles[ndx]
    end
end

function TileMap:set_tile(tx,ty,tile)
    if tx < 0 or ty < 0 then
        assert(true,'illegal coordinate given')
    else
        tile.tx = tx
        tile.ty = ty
        local ndx = ty * self.width + tx + 1
        self.tiles[ndx]=tile
    end
end

function TileMap:renderTiles()
    for k ,tile in pairs(self.tiles) do
       tile:render()
    end
end
