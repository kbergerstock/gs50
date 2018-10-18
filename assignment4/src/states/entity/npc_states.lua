--[[
    GD50
    Super Mario Bros. Remake

    -- SnailIdleState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals Entity
-- luacheck: globals gSounds gTextures gFrames gFonts gCT

function NPC_states(def)
    local self = {}
    local tile_map = def.tile_map
    local player = def.player

    function self.start(npc)
        npc.next(self.npc_enter_idle)
    end

    function self.npc_enter_idle(npc)
        assert(npc.name() =='snail', ' OOPS NPC idle state is trying to process a '.. npc.name())
        npc.direction = 0
        npc.animate:Start(1000)
        npc.timer:start(math.random(1000,3000))
        npc.animate:setFrames(npc:selectFrames())
        npc.next(self.npc_update_idle)
    end

    local function chase_sensor(npc)
        -- calculate difference between snail and player on X axis
        -- and only chase if <= 5 tiles
        local diffX = npc.tx - player.tx
        if diffX < 0 then diffX = diffX * -1 end
        return (diffX < 5)
    end

    -- returns true if the conditions to move to the next tile are true
    local function look_ahead(npc)
        local stop = false
        local t_next = tile_map:getTile(npc.tx + npc.direction, npc.ty)
        local t_bottom = tile_map:getTile(npc.tx + npc.direction, npc.ty - 1)
        assert(t_next and t_bottom,"an entity is outside of the tilemap")
        return (t_next == gCT.TILE_ID_EMPTY) and (t_bottom == gCT.TILE_ID_GROUND)
    end

    function self.npc_update_idle(npc)
        npc.animate:update()

        if npc.timer:elapsed() then
            npc.next(self.npc_enter_moving)
        end

        if chase_sensor(npc) then
            npc.next(self.npc_enter_chase)
        end
    end

    function self.npc_enter_moving(npc)
        -- verify we are working on a snail entity
        -- set the distance in tiles to move
        -- if the npc is not home then it will ead for home
        -- otherwise it will move a random distance away grom home
        npc:move_start()
        -- update the current frame to be displayed
        npc.animate:setFrames(npc:selectFrames())
        npc.next(self.npc_update_moving)
    end

    -- move randomly off home and then back
    function self.npc_update_moving(npc)
        npc.animate:update()
        local wf , sf = npc:move_x()
        if wf then          -- movement complete flag is set
            npc:move_start()
            npc.animate:setFrames(npc:selectFrames())
        elseif sf then      -- tile complete flag is set
            -- chance to go into idle state randomly
            if math.random(4) == 1 then
                npc.next(self.npc_enter_idle)
            end
            -- stop the snail if there's a missing tile on the floor  or a solid tile in the direction entity is moving
            if not look_ahead(npc) then
                -- reverse directions and move home
                npc:move_start()
                npc.animate:setFrames(npc:selectFrames())
            end
        end

        if chase_sensor(npc) then
            npc.next(self.npc_enter_chase)
        end
    end

    function self.npc_enter_chase(npc)
        -- verify we are working on a snail entity
        assert(npc.name() =='snail', ' OOPS NPC idle chase is trying to process a '.. npc.name())
        -- update the current frame to be displayed
        npc:chase_start()
        npc.animate:setFrames(npc:selectFrames())
        npc.next(self.npc_update_chase)
    end

    function self.npc_update_chase(npc)
        npc.animate:update()
        local wf = npc:move_x()
        if wf then          -- movement complete
            if not chase_sensor(npc) then npc.next(self.npc_enter_moving) end
            if look_ahead(npc) then
                npc:chase_start()
                npc.animate:setFrames(npc:selectFrames())
            end
        end
    end

    return self
end