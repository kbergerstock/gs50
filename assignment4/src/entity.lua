--[[
    GD50
    -- Entity Class --
    --  based on sprite class
    K.r.bergerstock
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor Animation Sprite
-- luacheck: ignore Entity

require 'lib/sprite'
require 'lib/Log'

function Entity(def)
    self = Sprite(def)

    function Sense(map)
    end

    self.state = 1
    self.gv = def.gravity
    self.gd = 0
    -- note to self
    -- origin of tiles is upper lower corner
    -- origin of sprites is lower right corner
    -- so a sprite plotted at (32,48) stands atop a tile plotted at (32,48)
    -- map origin (0,0) is lower right corner
    function self.apply_gravity(self, map, dt)
        local tx, ty = map:screen_to_tile(self.sx , self.sy )
        local tile_1 = map:get_tile(tx,ty)
        local tile_2 = map:get_tile(tx,ty - 1)
        local ts1 = tile_1.sy + map.tile_size         -- top edge of tile  directly under sprite
        local ts2 = tile_2.sy + map.tile_size
        local rv = 0
        self.state = 1
        -- distance due to gravity effect
        -- COMPUT ONCE EACH FRAME AND ADD TO USER DIRECTIONAL INPUT
        self.gv = self.gv + map.gravity * dt
        self.gd = self.gd + self.gv * dt

        if self.sy <= 1 then
            self.gv = map.gravity
            self.state = 0  -- ie dead
            self.gd = 0
            self.sy = 1
        elseif (tile_1.id == ID.EMPTY or tile_1.id == ID.WATER or tile_1.id == ID.WAVE) and
                (tile_2.id == ID.EMPTY or tile_2.id == ID.WATER or tile_2.id == ID.WAVE) then
            rv, self.gd = mod2(self.gd, 1)
            return rv
        elseif tile_1.id ~= ID.EMPTY  then
            if self.gd > (self.sy - ts1)  then
                self.gv = map.gravity
                rv = self.sy - ts1
                self.gd = 0
            else
                rv, self.gd = mod2(self.gd, 1)
            end
            return rv
        elseif tile_2.id ~= ID.EMPTY then
            if self.gd > (self.sy - ts2)  then
                self.gv  = map.gravity
                rv = self.sy - ts2
                self.gd = 0
            else
                rv, self.gd = mod2(self.gd, 1)
            end
            return rv
        end
        return 0
    end

    function self.move(self, dx, dy, map, dt)
        self.sx = self.sx + dx
        self.sy = self.sy + dy - self.apply_gravity(self, map, dt)
    end

    return self
end