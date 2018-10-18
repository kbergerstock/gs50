-- player character states
keith r bergerstock

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts CONST

function PC_states(def)
    self = {}
    local tlie_map = def.tile_map
    
    self function start(pc)
        pc.next(self.pc_idle)
    end
    
    return self
end