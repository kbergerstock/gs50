--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class mod2 setColor love gRC ID

baseTile = Class{}
function baseTile:init(def)
        -- tx and ty are zero based indices
        self.id = def.id
        self.tx = def.tx
        self.ty = def.ty
        self.sx = def.tx * def.tile_size
        self.sy = def.ty * def.tile_size
end

function baseTile:render() assert(false,'oops') end
-- --------------------------------------------------------------------
Tile = Class{__include = baseTile}

function Tile:init(def)
    baseTile.init(self,def)
    self.texture = gRC.textures['tiles']
    assert(self.texture, 'missing ground texture -> id '..tostring(def.id) )
    local x, y
    y, x = mod2(def.tile_set - 1, def.tile_sets_wide)
    self.tdx = y * def.tile_set_height * def.tile_sets_wide * def.tile_set_width + x * def.tile_set_width
    y, x  = mod2(def.sdx - 1, def.tile_set_width)
    self.tdx = self.tdx + y * def.tile_sets_wide * def.tile_set_width + x + 1
    self.frame = gRC.frames['tiles'][self.tdx]
    assert(self.frame, 'missing ground quad -> id '..tostring(def.id) )
    if def.id == ID.TOPPER then
        local w, h
        self.topper_texture = gRC.textures['toppers']
        w, h = self.topper_texture:getDimensions()
        y, x = mod2(def.topper_set - 1, def.tile_sets_wide)
        y = y * 64
        x = x * 80
        self.topper_frame = love.graphics.newQuad(x , y , def.tile_size, def.tile_size, w, h)
    end
end

function Tile:render()
    local mx = self.sx
    local my = 144 - self.sy
    love.graphics.draw(self.texture,self.frame, mx, my)
    -- tile top layer for graphical variety
    if self.id == ID.TOPPER then
         love.graphics.draw(self.topper_texture, self.topper_frame, mx, my)
    end
end
-- --------------------------------------------------------------------
Wave = Class{__include = baseTile}

function Wave:init(def)
    baseTile.init(self,def)
    self.texture = gRC.textures['water']
    assert(self.texture,'missing water image -> id = '..tostring(def.id) )
    local tdx = def.sdx + def.wave_set - 1
    self.frame = gRC.frames['water'][tdx]
    assert(self.frame,'missing water quad -> id = '..tostring(def.id) )
end

function Wave:render()
    local mx = self.sx
    local my = 144 - self.sy
    love.graphics.draw(self.texture, self.frame, mx, my)
end
-- --------------------------------------------------------------------
aTile = Class{__include = baseTile}

function aTile:init(def)
    baseTile.init(self,def)
    self.texture = gRC.textures[def.tile_set]
    self.frame = gRC.frames[def.tile_set][def.sdx]
    assert(self.frame,'tile set  '..def.tile_set..'  sdx  '.. tostring(def.sdx) )
end

function aTile:render()
    local mx = self.sx
    local my = 144 - self.sy
    love.graphics.draw(self.texture, self.frame, mx, my)
end