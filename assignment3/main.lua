-- common start up code for a love2d engine
-- create an app Class to implement game
-- K. R. Bergerstock @ 09/2018

-- luacheck: allow_defined, no unused
-- luacheck: globals Class push love gConst APP app 

-- initialize our nearest-neighbor filter
love.graphics.setDefaultFilter('nearest', 'nearest')

-- this time, we're keeping all requires and assets in our Dependencies.lua file
require 'src/Dependencies'
require 'src/app'

function love.load()
    loadConstants()
    -- initialize our virtual resolution
    push:setupScreen(gConst.VIRTUAL_WIDTH, gConst.VIRTUAL_HEIGHT, gConst.WINDOW_WIDTH, gConst.WINDOW_HEIGHT, {
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