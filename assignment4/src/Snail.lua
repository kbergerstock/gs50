--[[
    GD50
    Super Mario Bros. Remake

    -- Snail Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals love Entity gCT gTextures gFrames
-- luacheck: ignore Snail

require 'src/Entity'

function Snail(def)
    def.x = def.x
    def.y = def.y + 1
    def.offset_x = 0
    def.offset_y = 0
    def.normal = 'left'
    def.name = 'snail'
    self = Entity(def)

    local tile_size = gCT.TILE_SIZE
    local speed = gCT.SNAIL_MOVE_SPEED

    local mx = 0        -- tile complete counter
    local my = 0
    local rx = 0        -- movement complete goal
    local wx = 0        -- movement complete counter
    local st = 0

    function self.selectFrames(self)
        if self.direction == 1 then
            return {2,4}
        elseif self.direction == -1 then
            return{1,3}
        else
            return{5}
        end
    end

    function self.move_start(self)
        if self. tx ~= self.hx then
            if self.tx > self.hx then
                self.direction = -1
                rx = self.tx - self.hx
            else
                mx = 0
                self.direction = 1
                rx = self.hx - self.tx
            end
        else
            rx = math.random(2,5)
            self.direction = math.random(2) == 1 and 1 or -1
        end
        rx = rx * tile_size
        wx = 0
        st = love.timer.getTime()
    end

    -- sprite move / walk function
    function self.move_x(self)
        local et = love.timer.getTime()
        local dt = et - st
        local sf = false    -- tile complete flag
        local wf = false    -- movement complete flag
        local dd = speed * dt
        mx = mx + dd
        wx = wx + dd
        wf = wx >= rx       -- movement complete flag
        -- adjust tx to reflect movement over a whole tile
        if mx >= 16 then
            sf = true
            mx = mx - 16
            self.tx = self.tx + self.direction
        end
        st = et
        -- return movement complete flag and tile complete flag
        self.offset_x = mx * self.direction
        return wf, sf
    end

    -- input is player tx position
    function self.chase_start(self,ptx)
        if self.tx > ptx then
            self.direction = -1
        else
            self.direction = 1
        end
        rx = tile_size
        wx = 0
        mx = 0
        st = love.timer.getTime()
    end

    return self
end