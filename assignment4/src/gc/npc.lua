--[[
    -- NPC Class --
    -- non player character

    k.r.bergerstock
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals love Entity gCT gRC.textures gRC.frames
-- luacheck: ignore NPC

require 'src/gc/Entity'

function NPC(def)
    local speed = def.speed
    self.selectFrames = def.select_frames
    self = Entity(def)

    self.rx = 0        -- movement complete goal
    self.wx = 0        -- movement complete counter
    self.st = 0

    function self.move_start(self)
        -- ONLY USED WHAN AT HOME POSITION
        self.rx = self.tile_size * math.random(2,5)
        self.Hdirection = math.random(2) == 1 and 1 or -1
        self.animate:setFrames(self:selectFrames(self.Hdirection))
        self.st = love.timer.getTime()
    end

    function self.move_opposite(self)
        -- USED WHEN ENCOUNTERED A barrier in the path
        self.rx = self.tile_size * math.random(1,4)
        self.Hdirection = self.Hdirection * -1
        self.animate:setFrames(self:selectFrames(self.Hdirection))
        self.st = love.timer.getTime()
    end

    function self.move_home(self)
        if math.abs(self.hx - self.mx) >= 1 then
            if self.mx > self.hx then
                self.Hdirection = -1
                self.rx = self.mx - self.hx
            else
                self.Hdirection = 1
                self.rx = self.hx - self.mx
            end
            self.animate:setFrames(self:selectFrames(self.Hdirection))
            self.st = love.timer.getTime()
        end
    end

    -- all sensors return true  on target dectected, false otherwise

    function self.sense_home(self)
        if math.abs(self.hx - self.mx) < 1 then
            return true
        else
            return false
        end
    end

    function self.sense_move_end(self)
        if math.abs((self.hx + self.rx * self.Hdirection) - self.mx) < 1 then
            return true
        else
            return false
        end
    end

    function self.sense_barrier(self, map)
        local x, xr = 0, 0
        local y, yr = 0, 0
        local t1 = nil
        local t2 = nil
        local xn = self.mx + 2 * self.Hdirection
        local yn = self.my - 8
        if self.Hdirection == 1 then
            xn = xn + self.width
        end
 
        y, yr = mod2(self.my, self.tile_size)
        x, xr = mod2(xn, self.tile_size)
        t1 = map:getTile(x, y)

        y, yr = mod2(yn, self.tile_size)
        t2 = map:getTile(x, y)

        if t1.id == gCT.TILE_ID_GROUND or t2.id == gCT.TILE_ID_EMPTY then
            return true
        else
            return false
        end
    end

    -- sprite move / walk function
    function self.move_x(self)
        local et = love.timer.getTime()
        local dt = et - self.st
        local dd = speed * dt
        self.mx = self.mx + dd * self.Hdirection
        self.st = et
    end

    return self
end