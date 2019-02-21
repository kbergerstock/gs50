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
require 'src/loadConstants'

-- luacheck: allow_defined, no unused
-- luacheck: globals love readOnly GenerateQuads GenerateTileSets
-- luacheck: ignore LoadResources loadConstants

function LoadResources()
    -- the resources are loaded into read only tables
    local p = loadConstants()
    -- sounds and music
    local sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav','static'),
        ['death'] = love.audio.newSource('sounds/death.wav','static'),
        ['music'] = love.audio.newSource('sounds/frozen_orchard.mp3','stream'),
        ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav','static'),
        ['pickup'] = love.audio.newSource('sounds/pickup.wav','static'),
        ['empty-block'] = love.audio.newSource('sounds/empty-block.wav','static'),
        ['kill'] = love.audio.newSource('sounds/kill.wav','static'),
        ['kill2'] = love.audio.newSource('sounds/kill2.wav','static')
    }
    p.sounds = readOnly(sounds)

    local textures = {
        ['tiles']       = love.graphics.newImage('graphics/tiles.png'),
        ['toppers']     = love.graphics.newImage('graphics/tile_tops.png'),
        ['bushes']      = love.graphics.newImage('graphics/bushes_and_cacti.png'),
        ['jump-blocks'] = love.graphics.newImage('graphics/jump_blocks.png'),
        ['gems']        = love.graphics.newImage('graphics/gems.png'),
        ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
        ['green-alien'] = love.graphics.newImage('graphics/green_alien.png'),
        ['blue-alien']  = love.graphics.newImage('graphics/blue_alien.png'),
        ['snails']      = love.graphics.newImage('graphics/snails.png'),
        ['numbers']     = love.graphics.newImage('graphics/numbers.png'),
        ['water']       = love.graphics.newImage('graphics/water.png'),
        ['ladders']     = love.graphics.newImage('graphics/ladders_and_signs.png'),
        ['mushrooms']   = love.graphics.newImage('graphics/mushrooms.png'),
        ['crates']      = love.graphics.newImage('graphics/crates_and_blocks.png'),
    }
    p.textures = readOnly(textures)

    local frames = {
        ['tiles']       = GenerateQuads(textures['tiles'], p.TILE_SIZE, p.TILE_SIZE),
        ['toppers']     = GenerateQuads(textures['toppers'], p.TILE_SIZE, p.TILE_SIZE),
        ['bushes']      = GenerateQuads(textures['bushes'], 16, 16),
        ['jump-blocks'] = GenerateQuads(textures['jump-blocks'], 16, 16),
        ['gems']        = GenerateQuads(textures['gems'], 16, 16),
        ['backgrounds'] = GenerateQuads(textures['backgrounds'], 256, 128),
        ['green-alien'] = GenerateQuads(textures['green-alien'], 16, 20),
        ['blue-alien']  = GenerateQuads(textures['blue-alien'], 16, 20),
        ['snails']      = GenerateQuads(textures['snails'], 16, 16),
        ['numbers']     = GenerateQuads(textures['numbers'],8,8),
        ['water']       = GenerateQuads(textures['water'],16,16),
        ['ladders']     = GenerateQuads(textures['ladders'],16,16),
        ['mushrooms']   = GenerateQuads(textures['mushrooms'],16,16),
        ['crates']      = GenerateQuads(textures['crates'],16,16)
    }

    p.frames = readOnly(frames)

    local fonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
        ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
   }
   p.fonts = readOnly(fonts)
   return readOnly(p)
end