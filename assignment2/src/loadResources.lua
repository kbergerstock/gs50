-- loadResourses
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly
-- luacheck: globals GenerateQuadsBalls GenerateQuadsPaddles GenerateQuadsBricks GenerateQuads
-- luacheck: ignore loadResources

require 'lib/readonly'

function loadResources()
    gRSC ={}
    -- initialize constants
    local constants = {}

    -- size of our actual window
    constants.WINDOW_WIDTH = 1280
    constants.WINDOW_HEIGHT = 720

    -- size we're trying to emulate with push
    constants.VIRTUAL_WIDTH = 432
    constants.VIRTUAL_HEIGHT = 243

    -- paddle movement speed
    constants.PADDLE_SPEED = 250

    gRSC.W = readOnly(constants)
    assert(gRSC.W,"error in creating constants")

    -- initialize our nice-looking retro text fonts
    local fonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }

    -- load up the graphics we'll be using throughout our states
    local textures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    -- Quads we will generate for all of our textures; Quads allow us
    -- to show only part of a texture and not the entire thing
    local frames = {
        ['arrows'] = GenerateQuads(textures['arrows'], 24, 24),
        ['paddles'] = GenerateQuadsPaddles(textures['main']),
        ['balls'] = GenerateQuadsBalls(textures['main']),
        ['bricks'] = GenerateQuadsBricks(textures['main']),
        ['hearts'] = GenerateQuads(textures['hearts'], 10, 9)
    }

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    local sounds = {
        ['music']  = love.audio.newSource('sounds/music.wav','stream'),
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
        ['score'] = love.audio.newSource('sounds/score.wav','static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav','static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav','static'),
        ['select'] = love.audio.newSource('sounds/select.wav','static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav','static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav','static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav','static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav','static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav','static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav','static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav','static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav','static'),
    }

    gRSC.sounds = readOnly(sounds)
    gRSC.textures = readOnly(textures)
    gRSC.frames = readOnly(frames)
    gRSC.fonts  = readOnly(fonts)
end