-- common start up code for a love2d engine
-- create an app Class to implement game
-- K. R. Bergerstock @ 09/2018

-- luacheck: allow_defined, no unused
-- luacheck: globals Class push love gRSC init_message_packet StateMachine loadResources

-- initialize our nearest-neighbor filter
love.graphics.setDefaultFilter('nearest', 'nearest')

-- this time, we're keeping all requires and assets in our Dependencies.lua file
require 'src/Dependencies'

function love.load()
    -- window bar title
    love.window.setTitle('Match 3')

    loadResources()

    -- keep track of scrolling our background on the X axis
    local bgX = 0        -- x location of background
    local bgS = 80       -- background scroll speed
    local bgW = -1024 + gRSC.W.VIRTUAL_WIDTH - 4 + 51
    -- seed the RNG
    math.randomseed(os.time())
    -- initialize our virtual resolution
    push:setupScreen(gRSC.W.VIRTUAL_WIDTH, gRSC.W.VIRTUAL_HEIGHT, gRSC.W.WINDOW_WIDTH, gRSC.W.WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })
    -- initialize and start statemachine
    local msg = init_message_packet()
    local gameStateMachine = StateMachine()
    gameStateMachine:run(msg,'start')

    -- encapsulate the love callback so they have access to locals
    function love.resize(w, h)
        push:resize(w, h)
    end

    function love.keypressed(key)
        if key == 'escape' then
            -- quit if the escape was detectd
            gRSC.sounds['music']:stop()
            love.event.quit()
          else
            gameStateMachine:handle_input(msg, key)
        end
    end

    function love.update(dt)
        -- scroll background, used across all states
        bgX = bgX - bgS * dt
        -- if we've scrolled the entire image, reset it to 0
        if bgX <= bgW then bgX = 0 end
        -- execute the state machine
        gameStateMachine:update(msg, dt)
        if msg:getNext() == 'quit' then
            gRSC.sounds['music']:stop()
            love.event.quit()
        end
    end

    function love.draw()
        push:start()
        -- scrolling background drawn behind every state
        love.graphics.draw(gRSC.textures['background'], bgX, 0)
        -- render the current state
        gameStateMachine:render(msg)
        push:finish()
    end
end