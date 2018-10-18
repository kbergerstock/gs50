--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts gCT

PlayState = Class{__includes = BaseState}

function PlayState:init()
    BaseState:init()
    self.camX = 0
    self.camY = 0
    -- seed the RNG
    self.backgroundX = 0
    self.zt = 0
    self.canvas = love.graphics.newCanvas(1600,160)
    self.game_pad = GamePad()
end

function PlayState:enter(gameMsg)
    math.randomseed(os.time())
    for i = 1, math.random(1000,1500) do
        math.random(100)
    end
    local alien = Player({
        x = 2,
        y = 7,
        width   = 16,
        height  = 20,
        texture = 'green-alien',
    })

    self.tile_map = generateTileMap(100,10)
    self.player = alien
    self.entities = generateNPCs()
    self.fsm = NPC_states({tile_map = self.tile_map,player = self.player})
    self.pan = 0
    self.pos = 0
    for k,npc in pairs(self.entities) do
        self.fsm.start(npc)
    end

    self:update_canvas()
    self.background = math.random(3)
end

function PlayState:update_canvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0,0,0,0)
    self.tile_map:renderTiles()
    self.tile_map:renderObjects()
    self.player:render()
    for k, npc in pairs(self.entities) do
        npc:render()
    end
    love.graphics.setCanvas()
end

function PlayState:update(gameMsg,dt)
    self.zt = self.zt + dt * 1000
    if self.zt >=25 then
    local gpr = self.game_pad:input()
        if gpr then
            if self.pan == 0 and gpr.rightx > 0.6 then self.pan = 1; end
            if self.pan == 0 and gpr.rightx < -0.6 then self.pan = -1; end
        end

        for k, npc in pairs(self.entities) do
            npc.exec()
        end
        self:update_canvas()
        self.zt = self.zt - 25.0
    end
end

function PlayState:handle_input(input,gameMsg)
    if input == 'right' and self.pan == 0 then
        self.pan = 1
    end
    if input == 'left' and self.pan == 0 then
        self.pan = -1
    end
end

function PlayState:render(gameMsg)
    local bkgnds = 'backgrounds'

    -- render score
    local function renderScore(score)
        local ssx = 5
        local ssy = 5
        local d = 1000000
        local q = 0
        local r = score
        for i = 1, 6 do
            q, r = mod2 (r, d)
            d = d / 10
            love.graphics.draw(gTextures['numbers'],gFrames['numbers'][q+1],ssx,ssy)
            ssx = ssx + 10
        end
        love.graphics.draw(gTextures['numbers'],gFrames['numbers'][r+1],ssx,ssy)
    end

    local function gSX(u)
        return math.floor(-self.backgroundX + u)
    end
    local function gSY()
        return gTextures[bkgnds]:getHeight() / 3 * 2
    end

    love.graphics.push()
    love.graphics.draw(gTextures[bkgnds], gFrames[bkgnds][self.background], gSX(0), 0)
    love.graphics.draw(gTextures[bkgnds], gFrames[bkgnds][self.background], gSX(0), gSY(),0, 1, -1)
    love.graphics.draw(gTextures[bkgnds], gFrames[bkgnds][self.background], gSX(256), 0)
    love.graphics.draw(gTextures[bkgnds], gFrames[bkgnds][self.background], gSX(256), gSY(), 0, 1, -1)

    -- translate the entire view of the scene to emulate a camera
    -- love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    local quad = love.graphics.newQuad(16 + self.pos, 0, 256,160,1600,160)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas,quad)
    love.graphics.pop()
    renderScore(self.player.Score)
    if self.pan ~= 0 then
        self.pos = self.pos + self.pan
        if self.pos < 16 then self.pos = 16 end
        self.pan = 0
    end
end

function PlayState:updateCamera()
    local VW = gCT.VIRTUAL_WIDTH
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(gCT.TILE_SIZE * self.level.tileMap.width - VW, self.player.x - (VW / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end
