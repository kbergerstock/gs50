-- loadResourses
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly
-- luacheck: globals gSounds gTextures gFrames gFonts
-- luacheck: globals GenerateQuads

require 'lib/readonly'

function loadResources()

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

    gSounds = readOnly(sounds)
    gTextures = readOnly(textures)
    gFrames = readOnly(frames)
    gFonts = readOnly(fonts)
end