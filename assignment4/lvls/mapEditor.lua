-- map editor for 2D editors
-- k.r.bergerstock

-- luacheck: globals love LoadResources push Class Level GamePad TileMap Canvas mod2 gRC
-- luacheck: ignore APP

push = require 'lib/push'
require 'lib/GamePad'
require 'lib/sprite'
require 'lib/displayFPS'
require 'lvls/Level'
require 'src/loadResources'
require 'src/canvas'
require 'src/readGamePad'
require 'src/entity'


gRC = {}

APP = Class{}
-- ------------------------------------------------------------------
local function Initial()
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
end

function APP:run()
    local button
    local hInput
    local vInput
    -- read the level file
    local lines = read_file('oteron','oteron.L1')
    -- fetch  and store all resourses use in the application
    -- (sprites, tiles, sounds, quads and constants )
    gRC = LoadResources(lines)
    -- inital the virtual world
    Initial()

    -- create the level
    local level =  Level()
    local map = level:load(lines)
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
    def.sx = 2 * 16
    def.sy = 8 * 16
    def.gravity = map.gravity
    local player = Entity(def)
    sprites[1] = player

    canvas:updateBG(gRC.textures, gRC.frames)
    canvas:updateFG()

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
        elseif key == 'r' then
            restart()
        end
    end

    function restart()
        -- player.reset( def.playFrames )
        -- player.sx = def.sx
        -- player.sy = def.sy
        -- map.sx = 0
        -- player.state = 1
    end
    
    function love.update(dt)
        local dx = 0
            -- pass the inputs to be processed
            button,  hInput, vInput = readGamePad(self.gamePad)
        if player.state == PS.DEAD then
            -- fix display player died
            player:setFrames( { 4, } )
        else
            if button == 'GPb' then player:bounce(map.player_jump_speed) end
            for i, sprite in pairs(sprites) do
                sprite:update(dt)
                sprite:move(hInput , 0, map)
            end
            player:constrain(canvas.pos, canvas.pos + 126, 146,0)
            if player.sx == canvas.pos + 126 then
                canvas:updateRLpos(1)
            end
            canvas:updateFG()
            canvas:updateSprites(sprites)
        end
    end

    function love.draw()
        push:start()
        -- render the current map
        love.graphics.push()
        canvas:render()
        displayFPS(gRC.fonts['small'])
        love.graphics.print('walk speed '..tostring(map.player_walk_speed,20,20))
        love.graphics.print('sprite SY '..tostring(sprites[1].sy),20,50)
        love.graphics.print('sprite Sx '..tostring(sprites[1].sx),20,60)
        love.graphics.pop()

        push:finish()
    end
end