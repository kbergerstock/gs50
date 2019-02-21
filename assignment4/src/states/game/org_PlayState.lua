--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState gRC

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    -- seed the RNG
    self.backgroundX = 0
    self.zt = 0
    self.canvas = love.graphics.newCanvas(1600,160)
end

function PlayState:enter(msg)
    math.randomseed(os.time())
    for i = 1, math.random(1000,1500) do
        math.random(100)
    end

    local alien = Player({
        texture = 'green-alien',
        x = 2,
        y = 7,
        width   = 16,
        height  = 20,
    })
    local NPCs = generateNPCs()
    local map =  generateTileMap(100,10)

    self.player = alien
    assert(self.player,'player ref missing')
    self.entities = NPCs
    assert(self.entities,'no entities generated')
    self.tile_map = map
    -- player state machine
    self.psm = PC_states({tile_map = map,entities = NPCs})
    -- npc state machine
    self.fsm = NPC_states({tile_map = map,player = alien})
    self.pan = 0
    self.pos = 0
    -- start the action!
    self.psm.start(alien)
    for k, npc in pairs(NPCs) do
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
    -- update the display canvbas every 5 mS
    if self.zt >= 5.0 then
        self.player.exec()
        for k, npc in pairs(self.entities) do
            npc.exec()
        end
        self:update_canvas()
        self.zt = self.zt - 5.0
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
            love.graphics.draw(gRC.textures['numbers'],gRC.frames['numbers'][q+1],ssx,ssy)
            ssx = ssx + 10
        end
        love.graphics.draw(gRC.textures['numbers'],gRC.frames['numbers'][r+1],ssx,ssy)
    end

    local function gSX(u)
        return math.floor(-self.backgroundX + u)
    end
    local function gSY()
        return gRC.textures[bkgnds]:getHeight() / 3 * 2
    end

    love.graphics.push()
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][self.background], gSX(0), 0)
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][self.background], gSX(0), gSY(),0, 1, -1)
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][self.background], gSX(256), 0)
    love.graphics.draw(gRC.textures[bkgnds], gRC.frames[bkgnds][self.background], gSX(256), gSY(), 0, 1, -1)

    -- translate the entire view of the scene to emulate a camera
    -- love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    local quad = love.graphics.newQuad(16 + self.pos, 0, 256,160,1600,160)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas,quad)
    love.graphics.pop()
    renderScore(self.player.Score)
    if self.tile_map.pan ~= 0 then
        self.pos = self.pos + self.tile_map.pan
        if self.pos < 1 then self.pos = 0 end
        self.tile_map.pan = 0
    end
    love.graphics.setColor(0,0,0,1)
    love.graphics.print(tostring(self.player.tx),10,110)
    love.graphics.print(tostring(self.player.ty),10,130)
    love.graphics.print(tostring(self.player.offset_y),50,130)
    love.graphics.print(tostring(self.player.Vdirection),100,130)
end
--- fix
function PlayState:updateCamera()
    local VW = gCT.VIRTUAL_WIDTH
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(gCT.TILE_SIZE * self.level.tileMap.width - VW, self.player.x - (VW / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end
