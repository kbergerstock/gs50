-- common start up code for a love2d engine
-- create an app Class to implement game
-- K. R. Bergerstock @ 09/2018

-- lovecheck: allow_defined, no unused
-- loveCheck: globals Class
-- luacheck: ignore love push APP app
-- luacheck: ignore VIRTUAL_WIDTH VIRTUAL_HEIGHT WINDOW_WIDTH WINDOW_HEIGHT

-- initialize our nearest-neighbor filter
love.graphics.setDefaultFilter('nearest', 'nearest')

-- this time, we're keeping all requires and assets in our Dependencies.lua file
require 'src/Dependencies'
require 'src/app'

function love.load()
        -- initialize our virtual resolution
        push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })
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