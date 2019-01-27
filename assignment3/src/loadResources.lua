-- loadResourses
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly GenerateTileQuads generateGhostQuads
-- luacheck: ignore loadResources

require 'lib/readonly'
function loadResources()
    gRSC = {}
    -- constants
    local p = {}
    -- physical screen dimensions
    p.WINDOW_WIDTH = 1280
    p.WINDOW_HEIGHT = 720

    -- virtual resolution dimensions
    p.VIRTUAL_WIDTH = 512
    p.VIRTUAL_HEIGHT = 288
    gRSC.W = readOnly(p)

    -- sounds and music
    local sounds = {
        ['music'] = love.audio.newSource('sounds/music3.mp3','stream'),
        ['select'] = love.audio.newSource('sounds/select.wav','static'),
        ['error'] = love.audio.newSource('sounds/error.wav','static'),
        ['match'] = love.audio.newSource('sounds/match.wav','static'),
        ['clock'] = love.audio.newSource('sounds/clock.wav','static'),
        ['game-over'] = love.audio.newSource('sounds/game-over.wav','static'),
        ['next-level'] = love.audio.newSource('sounds/next-level.wav','static')
    }

    local textures = {
        ['main'] = love.graphics.newImage('graphics/match3.png'),
        ['ghost'] = love.graphics.newImage('graphics/Spooksel_n.png'),
        ['background'] = love.graphics.newImage('graphics/background.png')
    }

    local frames = {
        -- divided into sets for each tile type in this game, instead of one large
        -- table of Quads
        ['tiles'] = GenerateTileQuads( textures['main']),
        ['ghost'] = generateGhostQuads( textures['ghost'])
    }

    -- this time, we're keeping our fonts in a global table for readability
    local fonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }

    gRSC.textures = readOnly(textures)
    gRSC.frames = readOnly(frames)
    gRSC.fonts = readOnly(fonts)
    gRSC.sounds = readOnly(sounds)

    assert(gRSC.sounds,'the resources are not loaded!')

    -- set music to loop and start
    gRSC.sounds['music']:setLooping(true)
    gRSC.sounds['music']:play()
end