--[[
    GD50
    Match-3 version 2.0.1.1
    K.R.Bergerstock 09/2018
    total rewrite of Colton's code main is now just boiler plate
    along with a shell app class any project can be started, using the same main.lua fle

    credit to : Colton Ogden
    cogden@cs50.harvard.edu

    Match-3 has taken several forms over the years, with its roots in games
    like Tetris in the 80s. Bejeweled, in 2001, is probably the most recognized
    version of this game, as well as Candy Crush from 2012, though all these
    games owe Shariki, a DOS game from 1994, for their inspiration.

    The goal of the game is to match any three tiles of the same variety by
    swapping any two adjacent tiles; when three or more tiles match in a line,
    those tiles add to the player's score and are removed from play, with new
    tiles coming from the ceiling to replace them.

    As per previous projects, we'll be adopting a retro, NES-quality aesthetic.

    Credit for graphics (amazing work!):
    https://opengameart.org/users/buch

    Credit for music (awesome track):
    http://freemusicarchive.org/music/RoccoW/

    Cool texture generator, used for background:
    http://cpetry.github.io/TextureGenerator-Online/
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Message StateMachine StartState BeginGameState PlayState GameOverState BaseState
-- luacheck: globals Class setColor love GenerateTileQuads cHID VIRTUAL_WIDTH readOnly

require 'lib/readonly'

APP = Class{}

function APP:init()
    self.msg = Message()
    self.msg.goal = 0
    self.msg.board = {}
    self.msg.quit = false
    self.msg.seconds = 60              -- allowed time to find matches per board
    self.msg.clear_level_time = 120

    -- keep track of scrolling our background on the X axis
    self.bgX = 0        -- x location of background
    self.bgS = 80       -- background scroll speed
    self.bgW = -1024 + gConst.VIRTUAL_WIDTH - 4 + 51
end

function APP:load()
    -- window bar title
    love.window.setTitle('Match 3')
    assert(gSounds,'the resources are not loaded!')

    self.gameStateMachine = StateMachine {
        ['start']       =  StartState(),
        ['begin-game']  =  BeginGameState(),
        ['play']        =  PlayState(),
        ['game-over']   =  GameOverState(),
    }

    -- seed the RNG
    math.randomseed(os.time())

    self.msg.nextState('start')
end

function APP:handle_input(input, x, y)
    -- add to our table of keys pressed this frame
    if input == 'escape' then
        -- quit if the escape was detectd
        self:stop()
      else
        self.gameStateMachine:handle_input(input,self.msg)
    end
end

function APP:update(dt)
    -- scroll background, used across all states
    self.bgX = self.bgX - self.bgS * dt

    -- if we've scrolled the entire image, reset it to 0
    if self.bgX <= self.bgW then
        self.bgX = 0
    end
    -- execute the specific instance of the game states
    self.gameStateMachine:update(self.msg, dt)
    if self.msg.quit then
        self:stop()
    end
end

function APP:draw()
        -- scrolling background drawn behind every state
        love.graphics.draw(gTextures['background'], self.bgX, 0)
        -- render the current state
        self.gameStateMachine:render(self.msg)
end

function APP:loadResources()

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
        ['bombs'] = love.graphics.newImage('graphics/bombas.png'),
        ['background'] = love.graphics.newImage('graphics/background.png')
    }

    local frames = {
        -- divided into sets for each tile type in this game, instead of one large
        -- table of Quads
        ['tiles'] = GenerateTileQuads( textures['main']),
        ['bombs'] = generateBombQuads( textures['bombs'])
    }

    -- this time, we're keeping our fonts in a global table for readability
    local fonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }

    gSounds = readOnly(sounds)
    gTextures = readOnly(textures)
    gFrames = readOnly(frames)
    gFonts = readOnly(fonts)

    -- set music to loop and start
    gSounds['music']:setLooping(true)
    gSounds['music']:play()
end

function APP:stop()
    gSounds['music']:stop()
    love.event.quit()
end
