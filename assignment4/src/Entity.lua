--[[
    GD50
    Super Mario Bros. Remake

    -- Entity Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts gCT
-- luacheck: ignore Entity

require 'lib/fpStateMachine'

function Entity(def)
    self = fpStateMachine() or {}

    -- coodinates in tiles from bottom left corner
    self.tx = def.x
    self.ty = def.y
    -- home position
    self.hx = def.x
    self.hy = def.y
    -- entity dimensions
    self.width = def.width
    self.height = def.height
    -- offf sets used to adjust screen position
    self.offset_x = def.offset_x
    self.offset_y = def.offset_y
    self.texture = def.texture

     -- 1 is right -1 is left
    self.direction = math.random(2) == 1 and 1 or -1

    -- this must be started with an interval and a frame list
    self.animate = Animation()

    self.timer   = loveTimer()

    -- velocity
    self.dx = 0
    self.dy = 0

    self.Name(def.name)

    local tile_size = gCT.TILE_SIZE

     -- caclulates the top left corner of the animation graphic in screen pixels
    function self.csx(self)   return (self.tx - 1 ) * tile_size + self.offset_x end
    function self.csy(self)   return ((10 - self.ty) * tile_size ) + self.offset_y end

    -- returns true is collision is detected otherwise false
    function self.collides(self, npc)
        return   self.sx < (npc.sx + npc.width)  and
                 (self.sx + self.width) > npc.sx and
                 self.sy < (npc.sy + npc.height) and
                 (self.sy + self.height) > npc.sy
    end

    function self.render(self)
            local current_frame = self.animate:get_current_frame()
            local sx = self:csx()
            local sy = self:csy()
            if current_frame > 0 then
                love.graphics.draw(gTextures[self.texture], gFrames[self.texture][current_frame],sx ,sy)
            end
    end
    -- end of class defination
    return self
end