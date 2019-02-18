-- map editor for 2D editors
-- k.r.bergerstock

-- luacheck: globals love LoadResources push Class Level GamePad TileMap Canvas mod2 gRC
-- luacheck: ignore APP

push = require 'lib/push'
require 'lib/GamePad'
require 'lib/sprite'
require 'src/loadResources'
require 'src/canvas'
require 'src/readGamePad'
require 'lvls/Level'

gRC = {}

APP = Class{}
-- ------------------------------------------------------------------
local function Initial()
    -- fetch  and store all resourses use in the application
    -- (sprites, tiles, sounds, quads and constants )
    gRC = LoadResources()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- set window bar title
    love.graphics.setFont(gRC.fonts['medium'])
    love.window.setTitle("map editor")

    -- initialize our virtual resolution
    push:setupScreen(gRC.VIRTUAL_WIDTH, gRC.VIRTUAL_HEIGHT, gRC.WINDOW_WIDTH, gRC.WINDOW_HEIGHT, {
            vsync = true,
            fullscreen = false,
            resizable = true,
            canvas = true
        })
    -- seed the RNG
    math.randomseed(os.time())
    for i = 1, 100 do math.random(i * 100) end
end
-- ------------------------------------------------------------------
function APP:init()
    -- create a game pad interface
    self.gamePad = GamePad()
    Initial()
end

function APP:run()
    local button
    local hInput
    local vInput

    -- create the level
    local level =  Level()
    local map = level:load('oteronL1')
    local canvas = Canvas(map)
    local sprites = {}

    local def = {}
    def.width = 16
    def.height = 20
    def.offset = 160
    def.texture = gRC.textures['blue-alien']
    def.frames  = gRC.frames['blue-alien']
    def.interval = 250
    def.playFrames = {8,9,10,11}
    def.sx = 4.5 * 16
    def.sy = 8 * 16
    sprites[1] = Sprite(def)

    canvas:updateBG(gRC.textures, gRC.frames)
    canvas:updateFG(sprites)

       -- define love callbacks in this fuction body so they have access to local's
    function love.resize(w, h)
        push:resize(w, h)
    end

    -- stop the muisic and issue the exit cmd to the love system
    local function stop()
        love.event.quit()
    end

    function love.keypressed(key)
        if key == 'escape' then
            stop()
        end
    end

    function love.update(dt)
        -- pass the inputs to be processed
        button,  hInput, vInput = readGamePad(self.gamePad)
        for i, sprite in pairs(sprites) do
            sprite:update(dt)
            sprite:move(hInput,vInput)
        end
        canvas:updatePos(hInput)
        canvas:updateFG(sprites)
    end

    function love.draw()
        push:start()
        -- render the current map
        love.graphics.push()
        canvas:render()
        love.graphics.pop()

        push:finish()
    end
end