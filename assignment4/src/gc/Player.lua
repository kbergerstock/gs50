--[[
    GD50
    Super Mario Bros. Remake

    -- Player Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals love gCT Message Entity
-- luacheck: ignore Player

require 'src/gc/Entity'

function Player(def)
    def.y = def.y + 1
    def.offset_x = 0
    def.offset_y = -5
    def.name = 'Otarin'
    def.tile_size = gCT.TILE_SIZE
    self = Entity(def)

    local gravityOn = true
    local gravity = 3
    local max_x = self.tile_size * 100 - self.width
    local speed = 60
    local jump_v = -150
    local mx = def.x * self.tile_size + def.offset_x
    local my = def.y * sflg.tile_size + def.offset_y
    local dx, dy = 0,0
    local dv = 0
    local st = 0

     function self.move_reset()
        st = love.timer.getTime()
    end

    function self.jump()
        self.Vdirection = 1
        dv = 0
        dy = jump_v
    end

    function self.fall()
        self.Vdirection = -1
        dv = 0
        dy = 0
    end

    function self.walk(direction)
        self.Hdirection = direction
        dx = 0
    end

    -- sprite walk / jump / fall function
    function self.move(self)
        local et = love.timer.getTime()
        local dt = et - st
        -- local hf = false    -- tile complete flag
        -- local vf = false
        dv  =  gravity * dt * self.Vdirection
        dy  =  dv * self.Vdirection
        dx  = speed * dt * self.Hdirection
        mx = mx + dx
        my = my + dy
        if mx < 0 then mx = 0 end
        if mx > 1600 - 16 then mx = 1600 - 16 end
        -- if my < 16 then my = 16 end
        -- if my > 160 then my = 160 end
        -- if self.vDirection == 1 and dy > 0 then
        --     self.Vdirection = -1
        --     dv = 0
        --     dy = 0
        -- end
        -- adjust tx
        self.tx, self.offset_x = mod2(mx,16)
        self.ty, self.offset_y = mod2(my ,16)
 
        st = et
    end

    return self
end