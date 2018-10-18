-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor
-- luacheck: globals gSounds gTextures gFrames gFonts

function generateNPCs(c)
    local entities = {}

    -- create a snail npc character
    local function createSnail(tx, ty)
        -- instantiate snail
        local snail = Snail({
            texture = 'snails',
            x = tx,
            y = ty,
            width = 16,
            height = 16,
        })
        table.insert(entities, snail)
    end

    createSnail(8,4)
    createSnail(13,4)
    return entities
end