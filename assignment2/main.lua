--[[
    GD50
    Breakout Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Originally developed by Atari in 1976. An effective evolution of
    Pong, Breakout ditched the two-player mechanic in favor of a single-
    player game where the player, still controlling a paddle, was tasked
    with eliminating a screen full of differently placed bricks of varying
    values by deflecting a ball back at them.

    This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on
    modern systems.

    Credit for graphics (amazing work!):
    https://opengameart.org/users/buch

    Credit for music (great loop):
    http://freesound.org/people/joshuaempyre/sounds/251461/
    http://www.soundcloud.com/empyreanma
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState push gRSC GamePad
-- luacheck: globals loadResources init_msg_packet StartState PlayState ServeState GameOverState VictoryState
-- luacheck: globals  HighScoreState EnterHighScoreState PaddleSelectState StateMachine
-- luacheck: ignore renderHealth renderScore

require 'src/Dependencies'

--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]
function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- set the application title bar
    love.window.setTitle('Breakout')
    -- load the constatns and visual resources
    loadResources()
    -- set up gampad interface
    local gamePad = GamePad()

    love.graphics.setFont(gRSC.fonts['small'])
    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions

    push:setupScreen(gRSC.W.VIRTUAL_WIDTH, gRSC.W.VIRTUAL_HEIGHT, gRSC.W.WINDOW_WIDTH, gRSC.W.WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gRSC.sounds['music']:setLooping(true)
    gRSC.sounds['music']:setVolume(0.3)
    gRSC.sounds['music']:play()

    local msg = init_msg_packet()
    local gameStateMachine = StateMachine()

    -- the state machine we'll be using to transition between various states
    -- in our game instead of clumping them together in our update and draw
    -- methods
    --
    -- our current game state can be any of the following:
    -- 1. 'start' (the beginning of the game, where we're told to press Enter)
    -- 2. 'paddle-select' (where we get to choose the color of our paddle)
    -- 3. 'serve' (waiting on a key press to serve the ball)
    -- 4. 'play' (the ball is in play, bouncing between paddles)
    -- 5. 'victory' (the current level is over, with a victory jingle)
    -- 6. 'game-over' (the player has lost; display score and allow restart)
    msg.states['start']         =  StartState()
    msg.states['play']          =  PlayState()
    msg.states['serve']         =  ServeState()
    msg.states['game_over']     =  GameOverState()
    msg.states['victory']       =  VictoryState()
    msg.states['high_scores']   =  HighScoreState()
    msg.states['enter_name']    =  EnterHighScoreState()
    msg.states['paddle_select'] =  PaddleSelectState()

    --  start the state machine up
    msg.powerUps:generateQuads(gRSC.textures['main'])
    gameStateMachine:run(msg,'start')

    --[[
        Called whenever we change the dimensions of our window, as by dragging
        out its bottom corner, for example. In this case, we only need to worry
        about calling out to `push` to handle the resizing. Takes in a `w` and
        `h` variable representing width and height, respectively.
    ]]
    function love.resize(w, h)
        push:resize(w, h)
    end

    --[[
        Called every frame, passing in `dt` since the last frame. `dt`
        is short for `deltaTime` and is measured in seconds. Multiplying
        this by any changes we wish to make in our game will allow our
        game to perform consistently across all hardware; otherwise, any
        changes we make will be applied as fast as possible and will vary
        across system hardware.
    ]]
    function love.update(dt)
        local input = ''
        gamePad:readJoysticks()
        if  gamePad.inputs['f1lt'] then
            input = 'left'
        elseif  gamePad.inputs['f1rt'] then
            input = 'right'
        elseif  gamePad.inputs['f1up'] then
            input = 'up'
        elseif  gamePad.inputs['f1dn'] then
            input = 'down'
        elseif gamePad.inputs['b'] then
            input = 'space'
            gamePad.inputs['b'] = false
        elseif gamePad.inputs['a'] then
            input = 'p'
            gamePad.inputs['a'] = false
        end
        gameStateMachine:handle_input(msg, input)

        input = ''
        if  gamePad.inputs['j1lt'] or love.keyboard.isDown('left') then
            input = 'left'
        elseif  gamePad.inputs['j1rt'] or love.keyboard.isDown('right')  then
            input = 'right'
        end
        gameStateMachine:handle_inputs(msg, input)

        -- this time, we pass in dt to the state object we're currently using
        gameStateMachine:update(msg, dt)
    end

    --[[
        A callback that processes key strokes as they happen, just the once.
        Does not account for keys that are held down, which is handled by a
        separate function (`love.keyboard.isDown`). Useful for when we want
        things to happen right away, just once, like when we want to quit.
    ]]
    function love.keypressed(key)
        -- add to our table of keys pressed this frame
        if (key == 'f1') then
            gRSC.sounds['music']:stop()
        elseif (key == 'f2') then
            gRSC.sounds['music']:play()
        elseif key == 'escape' then
            gRSC.sounds['music']:stop()
            love.event.quit()
        else
            gameStateMachine:handle_input(msg, key)
        end
    end

    --[[
        Called each frame after update; is responsible simply for
        drawing all of our game objects and more to the screen.
    ]]
    function love.draw()
        -- begin drawing with push, in our virtual resolution
        push:apply('start')

        -- background should be drawn regardless of state, scaled to fit our
        -- virtual resolution
        local backgroundWidth = gRSC.textures['background']:getWidth()
        local backgroundHeight = gRSC.textures['background']:getHeight()

        love.graphics.draw(gRSC.textures['background'],
            -- draw at coordinates 0, 0
            0, 0,
            -- no rotation
            0,
            -- scale factors on X and Y axis so it fills the screen
        gRSC.W.VIRTUAL_WIDTH / (backgroundWidth - 1),
        gRSC.W.VIRTUAL_HEIGHT / (backgroundHeight - 1))

        -- use the state machine to defer rendering to the current state we're in
        gameStateMachine:render(msg)

        -- display FPS for debugging; simply comment out to remove
        displayFPS()

        push:apply('end')
    end
end

--[[
    Renders hearts based on how much health the player has. First renders
    full hearts, then empty hearts for however much health we're missing.
]]
function renderHealth(health)
    -- start of our health rendering
    local healthX = gRSC.W.VIRTUAL_WIDTH - 120
    local h = 1
    -- render health left
    for i = 1, 3 do
        if i <= health then h = 1 else h = 2 end
        love.graphics.draw(gRSC.textures['hearts'], gRSC.frames['hearts'][h], healthX, 4)
        healthX = healthX + 11
    end
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gRSC.fonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

--[[
    Simply renders the player's score at the top right, with left-side padding
    for the score number.
]]
function renderScore(score)
    love.graphics.setFont(gRSC.fonts['small'])
    love.graphics.print('Score:', gRSC.W.VIRTUAL_WIDTH - 80, 5)
    love.graphics.printf(tostring(score), gRSC.W.VIRTUAL_WIDTH - 70, 5, 60, 'right')
end