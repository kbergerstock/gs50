-- common start up code for a love2d engine
-- create an app Class to implement game
-- K. R. Bergerstock @ 09/2018

-- luacheck: allow_defined, no unused
-- luacheck: globals Class push love APP app
-- luacheck: ignore GAME_PADS

require 'src/Dependencies'
require 'src/app'

function love.load()
        local gc = loadConstants()
        -- initialize our virtual resolution
        push:setupScreen(gc.VIRTUAL_WIDTH, gc.VIRTUAL_HEIGHT, gc.WINDOW_WIDTH, gc.WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })
    -- create a game pad interface
    GAME_PADS = love.joystick.getJoysticks()
    -- create and initalize the application
    app = APP()
    -- load up the graphics, sounds and music
    app:loadResources()
    -- load everything else and start the state machine
    app:load()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    app:handle_input(key)
end

function love.update(dt)
    -- execute the state machine
    app:update(dt)
end

function love.draw()
    push:start()
    -- render the current state
    app:draw()
    push:finish()
end