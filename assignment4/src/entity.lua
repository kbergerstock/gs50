--[[
    GD50
    -- Entity Class --
    --  based on sprite class
    K.r.bergerstock
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor Animation Sprite mod2 sign BBox
-- luacheck: ignore Entity
require 'lib/readonly'
require 'lib/sprite'
Entity  = Class{__includes = Sprite }

function Entity:init(def)
    Sprite.init(self, def)
    self:setBox(self.sx, self.sy, self.width, self.height )
    local function seq_iter ()
        local i = 0
        return function ()
                    i = i + 1
                    return i
                end
        end
    local seq = seq_iter()
    local player_states = {
        IDLE = seq(),
        WALK = seq(),
        JUMP = seq(),
        CLIMB = seq(),
        FALL = seq(),
        DEAD = seq(),
    }
    PS = readOnly(player_states)
    self.state = PS.IDLE
    self.gv = def.gravity / 60
    self.gd = 0
    self.hd = 0
end

-- note to self
-- origin of tiles is lower left corner
-- origin of sprites is lower left corner
-- a sprite plotted at (32,48) stands atop a tile plotted at (32,48)
-- map origin (0,0) is lower left corner
function Entity:apply_gravity(map)
    local tx, ty , rx, ry = map:screen_to_tile(self.sx , self.sy )
    local tile_1 = map:get_tile(tx,ty)
    local tile_2 = map:get_tile(tx,ty - 1)
    local ts1 = tile_1.sy + map.tile_size         -- top edge of tile  directly under sprite
    local ts2 = tile_2.sy + map.tile_size
    local rv = 0
    -- distance due to gravity effect
    -- COMPUTE ONCE EACH FRAME AND ADD TO USER DIRECTIONAL INPUT
    self.gv = self.gv + map.gravity / 60
    self.gd = self.gd + self.gv
    
    if self.sy <= 1 then
        self.gv = map.gravity / 60
        self.state = PS.DEAD
        self.gd = 0
        self.sy = 1
    elseif map.transparent_ids[tile_1.id] and map.transparent_ids[tile_2.id] then
        rv, self.gd = mod2(self.gd, 1)
        return rv
    elseif  not map.transparent_ids[tile_1.id] then
        if self.gd > (self.sy - ts1)  then
            self.gv = map.gravity / 60
            rv = self.sy - ts1
            self.gd = 0
        else
            rv, self.gd = mod2(self.gd, 1)
        end
        return rv
    elseif  not map.transparent_ids[tile_2.id] then
        if self.gd > (self.sy - ts2)  then
            self.gv  = map.gravity / 60
            rv = self.sy - ts2
            self.gd = 0
        else
            rv, self.gd = mod2(self.gd, 1)
        end
        return rv
    end
    return 0
end
-- fix
function Entity:apply_motion(dx, map )
    local rv = 0
    self.hd = self.hd + dx * map.player_walk_speed / 60
    -- local tx, ty , rx , ry = map:screen_to_tile(self.sx +  nx , self.sy )
    -- local tile_1 = map:get_tile(tx , ty)
    -- local tile_2 = map:get_tile(tx + dx , ty)
    rv , self.hd = mod2(self.hd, 1)
    -- if map.collide_ids[tile_2.id] then
    --     if self:collides(tile_2) then
    --         return 0
    --     else
    --         return rv
    --     end
    -- else
         return rv
    -- end
end

function Entity:move(dx, dy, map)
    self.sy = self.sy - self:apply_gravity(map)
    self.sx = self.sx + self:apply_motion(dx, map)
    self:setBox(self.sx, self.sy, self.width, self.height)
    -- fix
end

function Entity:bounce(velocity)
    self.state = PS.JUMP
    self.gv = self.gv - velocity / 60
end