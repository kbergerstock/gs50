--[[
    GD50 2018
    Flappy Bird Remake

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping
    the screen, making the player's bird avatar flap its wings and move upwards slightly.
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]

-- luacheck: allow_defined,no unused
-- luacheck: globals love Class BaseState Inputs StateMachine Message GamePad
-- luacheck: globals WINDOW_WIDTH WINDOW_HEIGHT VIRTUAL_WIDTH VIRTUAL_HEIGHT
-- luacheck: globals PIPE_SPEED PIPE_WIDTH PIPE_HEIGHT
-- luacheck: globals BIRD_WIDTH BIRD_HEIGHT COUNTDOWN_TIME

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'lib/push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
-- Class = require 'lib/class'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
-- removed dependency on global instane of this class and made it local 07/15/2018 KRB
require 'lib/StateMachine'
require 'lib/message'
require 'lib/Inputs'
require 'lib/gamePad'
require 'src/constants'

-- all states our StateMachine can transition between
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

require 'src/Bird'
require 'src/Pipe'
require 'src/PipePair'
require 'src/trophies'

local background = love.graphics.newImage('img/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('img/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local gameStateMachine = StateMachine()
local msg = Message()
local gamePad = GamePad()

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG
    math.randomseed(os.time())

    -- app window title
    love.window.setTitle('Fifty Bird')
    msg.scrolling = false
    msg.user = Inputs()         -- create an input
    msg.mode = '2'              -- default to easy mode
    -- initialize state machine with all state-classes
    msg.states['title']       =  TitleScreenState()
    msg.states['countdown']   =  CountdownState()
    msg.states['play']        =  PlayState()
    msg.states['score']       =  ScoreState()

    -- initialize our nice-looking retro text fonts
    msg.fonts['small']  = love.graphics.newFont('fonts/font.ttf', 12)
    msg.fonts['medium'] = love.graphics.newFont('fonts/flappy.ttf', 14)
    msg.fonts['flappy'] = love.graphics.newFont('fonts/flappy.ttf', 28)
    msg.fonts['huge']   = love.graphics.newFont('fonts/flappy.ttf', 56)

    -- initialize our table of sounds
    msg.sounds['jump'] = love.audio.newSource('sounds/jump.wav', 'static')
    msg.sounds['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static')
    msg.sounds['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static')
    msg.sounds['score'] = love.audio.newSource('sounds/score.wav', 'static')
    msg.sounds['pause'] = love.audio.newSource('sounds/pause.wav','static')

    -- https://freesound.org/people/xsgianni/sounds/388079/
    msg.sounds['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')

    -- kick off music
    msg.sounds['music']:setLooping(true)
    msg.sounds['music']:play()

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- start the execution of the state machine
    gameStateMachine:run( msg, 'title')
end

function love.resize(w, h)
    push:resize(w, h)
end

    --[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
    if key == 'escape' then
        -- quit if the escape was detectd
        msg.sounds['music']:stop()
        love.event.quit()
    elseif key == '1' or key == '2' then
        msg.mode = key
    else
        gameStateMachine:handle_input(msg, key)
    end
end

--[[
    LÖVE2D callback fired each time a mouse button is pressed; gives us the
    X and Y of the mouse, as well as the button in question.
]]
function love.mousepressed(x, y, button)
    -- bug found !! pressing an up event fast enough will allow the bird to fly above the pipes
    if button == 1 then
        gameStateMachine:handle_input(msg, 'up')
    end
end

function love.update(dt)
    gamePad.readAxis()
    if gamePad.inputs['a'] then
        gameStateMachine:handle_input(msg,'p')
    end
    if gamePad.inputs['b'] then
        gameStateMachine:handle_input(msg,'space')
    end
    if gamePad.inputs['j1up'] then
        gameStateMachine:handle_input(msg,'up')
    end
    if gamePad.inputs['x'] then
        msg.mode = '2'
    end
    if gamePad.inputs['y'] then
        msg.mode = '1'
    end

    if msg.scrolling == true then
        scrollBackground(dt)
    end
    gameStateMachine:update(msg, dt)
end

function renderMode()
    local modeMsg = ''
    if msg.mode == '2' then
        modeMsg = 'EASY MODE SELECTED'
    else
        modeMsg = 'HARD MODE SELECTED'
    end
    love.graphics.setFont(msg.fonts['medium'])
    love.graphics.printf(modeMsg, 0, 250, VIRTUAL_WIDTH, 'center')
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)
    gameStateMachine:render(msg)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end

function checkBoundries(y)
    return math.max(-PIPE_HEIGHT + 10, math.min( y , VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT) )
end

function scrollBackground(dt)
        -- scroll our background and ground, looping back to 0 after a certain amount
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end