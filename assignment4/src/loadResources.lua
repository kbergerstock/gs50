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
require 'src/constants'

-- luacheck: allow_defined, no unused
-- luacheck: globals love readOnly GenerateQuads GenerateTileSets
-- luacheck: globals VIRTUAL_WIDTH VIRTUAL_HEIGHT
-- luacheck: ignore CONST GEMS BUSH_IDS COIN_IDS CRATES COLLIDABLE_TILES JUMP_BLOCKS
-- luacheck: ignore LoadResources gSounds gTextures gFrames gFonts

function LoadResources()
    -- the resources are loaded into read only tables

    local p = {
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
    p.SCREEN_TILE_WIDTH = VIRTUAL_WIDTH / p.TILE_SIZE
    p.SCREEN_TILE_HEIGHT = VIRTUAL_HEIGHT / p.TILE_SIZE
    -- total number of topper and tile sets
    p.TOPPER_SETS = p.TOPPER_SETS_WIDE * p.TOPPER_SETS_TALL
    p.TILE_SETS = p.TILE_SETS_WIDE * p.TILE_SETS_TALL

    CONST = readOnly(p)

    -- table of tiles that should trigger a collision
    COLLIDABLE_TILES = readOnly{ p.TILE_ID_GROUND }
    -- game object IDs
    BUSH_IDS = readOnly{1, 2, 5, 6, 7}
    COIN_IDS = readOnly{1, 2, 3}
    CRATES = readOnly{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
    GEMS = readOnly{1, 2, 3, 4, 5, 6, 7, 8 }

    local jb = {}
    for i = 1, 30 do
        table.insert(jb, i)
    end
    JUMP_BLOCKS = readOnly(jb)




    -- sounds and music
    local sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav','static'),
        ['death'] = love.audio.newSource('sounds/death.wav','static'),
        ['music'] = love.audio.newSource('sounds/music.wav','stream'),
        ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav','static'),
        ['pickup'] = love.audio.newSource('sounds/pickup.wav','static'),
        ['empty-block'] = love.audio.newSource('sounds/empty-block.wav','static'),
        ['kill'] = love.audio.newSource('sounds/kill.wav','static'),
        ['kill2'] = love.audio.newSource('sounds/kill2.wav','static')
    }
    gSounds = readOnly(sounds)

    local textures = {
        ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
        ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
        ['bushes'] = love.graphics.newImage('graphics/bushes_and_cacti.png'),
        ['jump-blocks'] = love.graphics.newImage('graphics/jump_blocks.png'),
        ['gems'] = love.graphics.newImage('graphics/gems.png'),
        ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
        ['green-alien'] = love.graphics.newImage('graphics/green_alien.png'),
        ['creatures'] = love.graphics.newImage('graphics/creatures.png')
    }
    gTextures = readOnly(textures)

    local frames = {
        ['tiles'] = GenerateQuads(gTextures['tiles'], p.TILE_SIZE, p.TILE_SIZE),
        ['toppers'] = GenerateQuads(gTextures['toppers'], p.TILE_SIZE, p.TILE_SIZE),
        ['bushes'] = GenerateQuads(gTextures['bushes'], 16, 16),
        ['jump-blocks'] = GenerateQuads(gTextures['jump-blocks'], 16, 16),
        ['gems'] = GenerateQuads(gTextures['gems'], 16, 16),
        ['backgrounds'] = GenerateQuads(gTextures['backgrounds'], 256, 128),
        ['green-alien'] = GenerateQuads(gTextures['green-alien'], 16, 20),
        ['creatures'] = GenerateQuads(gTextures['creatures'], 16, 16)
    }

    -- these need to be added after gFrames is initialized because they refer to gFrames from within
    frames['tilesets'] = GenerateTileSets(frames['tiles'],
        p.TILE_SETS_WIDE, p.TILE_SETS_TALL, p.TILE_SET_WIDTH, p.TILE_SET_HEIGHT)

    frames['toppersets'] = GenerateTileSets(frames['toppers'],
        p.TOPPER_SETS_WIDE, p.TOPPER_SETS_TALL, p.TILE_SET_WIDTH, p.TILE_SET_HEIGHT)

    gFrames = readOnly(frames)

    local fonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
        ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
   }
   gFonts = readOnly(fonts)

   return CONST
end