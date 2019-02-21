-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor Tile TileMap gRC
-- luacheck: ignore generateTileMap GameObject

--units for  width amd height is in tile size
function generateTileMap(width, height)
    -- converting from a two dimensional array to a single dimension
    -- this will improve rendering amd processing speed
    -- to access a tile should be (x-1) * height + y
    local tile_size =  gRC.TILE_SIZE
    local tiles = {}
    local objects = {}
    local tile_id = 0

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)
    ----------------------------------------------------
    local function set(tile)
        local ndx = tile.ty * width + tile.tx + 1
        tiles[ndx]=tile
    end
    ----------------------------------------------------
        -- insert into object list a new bush
        local function create_bush(tx,ty)
            table.insert(objects,
                GameObject {
                    texture = 'bushes',
                    x = tx,
                    y = ty + 1, -- the object must sit above the tile it was created from
                    width = tile_size,
                    height = tile_size,
                    tile_size = tile_size,
                    -- select random frame from bush_ids whitelist, then random row for variance
                    frame =  gRC.BUSH_IDS[math.random(# gRC.BUSH_IDS)] + (math.random(4)-1) * 7
                }
            )
        end
    ----------------------------------------------------
    -- insert into object list a new jump block
    local function create_jump_block(tx, ty)
        table.insert(objects,
            GameObject {
                texture = 'jump-blocks',
                x = tx,
                y = ty + 4,
                width = tile_size,
                height = tile_size,
                tile_size = tile_size,
                -- make it a random variant
                frame = math.random( gRC.JUMP_BLOCKS_FRAMES),
                collidable = true,
                hit = false,
                solid = true,

                -- collision function takes itself
                --onCollide = function(obj)
            })
    end
    ----------------------------------------------------
    local function make_tiles()
        local empty =  gRC.TILE_ID_EMPTY
        local ground =  gRC.TILE_ID_GROUND
        for tx = 1,100 do
            local col = 10
            if tx > 20 then
                if math.random(7) == 1 then
                    tile_id = empty
                else
                    tile_id = ground
                    if math.random(8) == 1 then col = 5 else col = 3 end
                end
            else
                tile_id = ground
                col = 3
            end
            if tx == 6 or tx == 16 then col = 5 end
            if tx == 11 then
                tile_id = empty
                col = 10
            end

            for ty = 1 , col do
                set(Tile(tx, ty, tile_id, nil, tileset, topperset))
            end

            if col < 10 then
                col = col + 1
                set(Tile(tx, col, tile_id, topper, tileset, topperset))
                if tx > 16 then
                    if math.random(8) == 1 then create_bush(tx,col) end
                    if math.random(10) == 1 then create_jump_block(tx,col) end
                end
                tile_id = empty
                col = col + 1
                for ty = col , 10 do
                    set(Tile(tx, ty, tile_id, nil, tileset, topperset))
                end
            end
        end
        create_bush(8,4)
        create_bush(16,6)
    end
    ----------------------------------------------------
    -- generate tile map
    make_tiles()
    local map = TileMap({ _width = width,
                          _height = height,
                          _tiles = tiles,
                          _objects = objects })
    return  map
end