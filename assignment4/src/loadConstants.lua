
-- K.R.Bergerstock 09/2018, 01/2019
-- store constants in a read only table

require 'lib/readonly'

-- luacheck: allow_defined, no unused, globals readOnly
-- luacheck: ignore loadConstants

function loadConstants()
    local p = {
        -- size of our actual window
        WINDOW_WIDTH = 1280,
        WINDOW_HEIGHT = 800,

        -- size we're trying to emulate with push
        VIRTUAL_WIDTH = 256,
        VIRTUAL_HEIGHT = 160,

        -- camera scrolling speed
        CAMERA_SPEED = 100,

        -- speed of scrolling background
        BACKGROUND_SCROLL_SPEED = 10,

        -- standard tile size
        TILE_SIZE = 16,

        -- number of tiles in each tile set
        TILE_SET_WIDTH  = 5,
        TILE_SET_HEIGHT = 4,

        -- number of tile sets in sheet
        TILE_SETS_WIDE = 6,
        TILE_SETS_TALL = 10,

        -- number of topper sets in sheet
        TOPPER_SETS_WIDE = 6,
        TOPPER_SETS_TALL = 18,



        -- player walking speed
        PLAYER_WALK_SPEED = 60,

        -- player jumping velocity
        PLAYER_JUMP_VELOCITY = -150,

        -- snail movement speed
        SNAIL_MOVE_SPEED = 10,
    }

    -- width and height of screen in tiles
    p.SCREEN_TILE_WIDTH = p.VIRTUAL_WIDTH / p.TILE_SIZE
    p.SCREEN_TILE_HEIGHT = p.VIRTUAL_HEIGHT / p.TILE_SIZE
    -- total number of topper and tile sets
    p.TOPPER_SETS = p.TOPPER_SETS_WIDE * p.TOPPER_SETS_TALL
    p.TILE_SETS = p.TILE_SETS_WIDE * p.TILE_SETS_TALL

    -- table of tiles that should trigger a collision
    p.COLLIDABLE_TILES = readOnly{ p.TILE_ID_GROUND }

    -- game object IDs
    p.BUSH_IDS = readOnly{1, 2, 5, 6, 7}
    p.COIN_FRAMES = 3
    p.CRATES_FRAMES =  12
    p.GEMS_FRAMES =  8
    p.JUMP_BLOCKS_FRAMES = 30

    return p
end