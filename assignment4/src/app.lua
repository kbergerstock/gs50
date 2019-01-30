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

-- luacheck: allow_defined, no unused
-- luacheck: globals push Message StateMachine  Class setColor love
-- luacheck: globals GamePad LoadResources StartState PlayState

push = require 'lib/push'
require 'src/loadResources'

APP = Class{}

function APP:init()
    -- create a game pad interface
    self.gamePad = GamePad()
    -- fetrch  and store all resourses use in the application (sprits, tiles, sounds, frames and constants )
    gRC = LoadResources()
end

function APP:Run()
    -- display the virtual window
    self:start()

    local msg = self:init_message_packet()
    local gameStateMachine = StateMachine()
    gameStateMachine:run(msg, 'start')

    -- define love callbacks in this fuction body so they have access to local's
    function love.resize(w, h)
        push:resize(w, h)
    end

    -- stop the muisic and issue the exit cmd to the love system
    local function stop()
        gRC.sounds['music']:stop()
        love.event.quit()
    end

    function love.keypressed(key)
        if key == 'escape' then
            stop()
        else
            gameStateMachine:handle_input(msg, key)
        end
    end

    function love.update(dt)
        -- pass the inputs to be processed
        local button = ''
        local hInput = ''
        local vInput = ''
        button,  hInput, vInput = self:readGamePad()
        gameStateMachine:handle_input(msg,button)
        gameStateMachine:handle_inputs(msg, hInput)
        gameStateMachine:handle_inputs(msg, vInput)
        -- execute the state machine and process inputs
        gameStateMachine:update(msg, dt)
    end

    function love.draw()
        push:start()
        -- render the current state
        gameStateMachine:render(msg)
        push:finish()
    end

end
-- ------------------------------------------------------------------
function APP:start()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- set window bar title
    love.graphics.setFont(gRC.fonts['medium'])
    love.window.setTitle("Otarin's Run.")

    -- initialize our virtual resolution
    push:setupScreen(gRC.VIRTUAL_WIDTH, gRC.VIRTUAL_HEIGHT, gRC.WINDOW_WIDTH, gRC.WINDOW_HEIGHT, {
            vsync = true,
            fullscreen = false,
            resizable = true,
            canvas = true
        })

    -- set music to loop and start
    gRC.sounds['music']:setLooping(true)
    gRC.sounds['music']:setVolume(0.5)
    gRC.sounds['music']:play()

    -- seed the RNG
    math.randomseed(os.time())
    for i = 1, 100 do math.random(100) end
end

function APP:readGamePad()
    local button = ''
    self.gamePad:readJoysticks()
    if  self.gamePad.inputs['f1lt'] then
        button = 'left'
    elseif  self.gamePad.inputs['f1rt'] then
        button = 'right'
    elseif  self.gamePad.inputs['f1up'] then
        button = 'up'
    elseif  self.gamePad.inputs['f1dn'] then
        button = 'down'
    elseif self.gamePad.inputs['b'] then    -- is true on detected false otherwise
        button = 'GPb'                        -- assign to return value
        self.gamePad.inputs['b'] = false    -- debounce the button
    elseif self.gamePad.inputs['a'] then
        button = 'GPa'
        self.gamePad.inputs['a'] = false
    elseif self.gamePad.inputs['x'] then
        button = 'GPx'
        self.gamePad.inputs['x'] = false
    elseif self.gamePad.inputs['y'] then
        button = 'GPy'
        self.gamePad.inputs['y'] = false
    end
    local hInput = ''
    if  self.gamePad.inputs['j1lt'] or love.keyboard.isDown('left') then
        hInput = 'GPleft'
    elseif  self.gamePad.inputs['j1rt'] or love.keyboard.isDown('right')  then
        hInput = 'GPright'
    end
    vInput = ''
    if  self.gamePad.inputs['j1up'] or love.keyboard.isDown('up') then
        vInput = 'GPup'
    elseif  self.gamePad.inputs['j1dn'] or love.keyboard.isDown('down')  then
        vInput = 'GPdown'
    end
    return button, hInput, vInput
end

function APP:init_message_packet()
    local msg = Message()
    msg.states['start'] = StartState()
    msg.states['play']  = PlayState()
    return msg
end
