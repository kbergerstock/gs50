--[[
    GD50
    Match-3 version 2.0.1.1
    K.R.Bergerstock 09/2018
    total rewrite of Colton's code main is now just boiler plate
    along with a shell app class any project can be started, uing the same main.lua fle

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