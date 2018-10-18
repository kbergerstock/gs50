--[[
    GD50
    Super Mario Bros. Remake

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Some global constants for our application.
]]


-- luacheck: allow_defined, no unused
-- luacheck: ignore VIRTUAL_WIDTH VIRTUAL_HEIGHT WINDOW_WIDTH WINDOW_HEIGHT
-- these must stay here because they are used by push in main


-- K.R.Bergerstock 09/2018
-- total rewrite of Colton's code, main is now just boiler plate
-- along with a shell app class any project can be started, using the same main.lua fle

--[[
    GD50
    super Mario bros remake

    credit to : Colton Ogden
    cogden@cs50.harvard.edu

        A classic platformer in the style of Super Mario Bros., using a free
    art pack. Super Mario Bros. was instrumental in the resurgence of video
    games in the mid-80s, following the infamous crash shortly after the
    Atari age of the late 70s. The goal is to navigate various levels from
    a side perspective, where jumping onto enemies inflicts damage and
    jumping up into blocks typically breaks them or reveals a powerup.

    Art pack:
    https://opengameart.org/content/kenney-16x16

    Music:
    https://freesound.org/people/Sirkoto51/sounds/393818/

]]

require 'lib/readonly'

-- luacheck: allow_defined, no unused, globals readOnly
-- luacheck: ignore loadConstants

function loadConstants()
    -- the constants are loaded into read only tables

    local p = {
        -- size of our actual window
        WINDOW_WIDTH = 1280,
        WINDOW_HEIGHT = 800,

        -- size we're trying to emulate with push
        VIRTUAL_WIDTH = 256,
        VIRTUAL_HEIGHT = 160,

        -- constants
        -- standard tile size
        TILE_SIZE = 16,

        -- camera scrolling speed
        CAMERA_SPEED = 100,

        -- speed of scrolling background
        BACKGROUND_SCROLL_SPEED = 10,

        -- number of tiles in each tile set
        TILE_SET_WIDTH = 5,
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

        -- tile IDs
        TILE_ID_EMPTY = 5,
        TILE_ID_GROUND = 3,
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

    gCT = readOnly(p)
    return gCT
end