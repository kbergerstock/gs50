--[[
    GD50
    -- Snail Class --
    k.r.bergerstock
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals love Entity NPC gCT gRC.textures gRC.frames
-- luacheck: ignore Snail

require 'src/gc/npc'

function Snail(def)
    def.x = def.x
    def.y = def.y + 1
    def.offset_x = 0
    def.offset_y = 0
    def.name = 'snail'
    def.tile_size = gCT.TILE_SIZE
    def.speed = gCT.SNAIL_MOVE_SPEED
    def.select_frames = self.selectFrames
    self = NPC(def)

    function self.selectFrames(self)
        if self.Hdirection == 1 then
            return {2,4}
        elseif self.Hdirection == -1 then
            return{1,3}
        else
            return{5}
        end
    end

    -- sense if a PC is withen 80 pixels npc
    function self.sense_PC(self, pc, npc)
        local _dx = npc.mx - pc.mx
        local _rx = math.abs(_dx)
        if _dx < 80 then
            return true
        end
        return false
    end

    return self
end