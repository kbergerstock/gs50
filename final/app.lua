-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'
-- require the map class
require 'Map'

App = Class{}

function App:init()
    self.window_width = 1280
    self.window_height = 720

    -- virtual resolution dimensions
    self.virtual_width = 512 
    self.virtual_height = 288
    self.map = Map()

end

function App:ndx(row,col)
    return (row * self.map_width) + col + 1 
end

function App:Load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG
    math.randomseed(os.time())

    -- app window title
    love.window.setTitle('Lost')

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    love.graphics.setFont(smallFont)

    -- initialize our table of sounds
    sounds = { }
        
    -- initialize our virtual resolution
    push:setupScreen(self.virtual_width, self.virtual_height, self.window_width, self.window_height, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function APP:update(dt)
end

function App:draw()
end
