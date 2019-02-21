-- spooks.lua
-- ghost sprites

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly gRSC
-- luacheck: ignore renderGhost generateGhostQuads


function renderGhost(x, y, frame)
    setColor(255,255,255,96)
    love.graphics.draw(gRSC.textures['ghost'], gRSC.frames['ghost'][frame],x, y)
end

--------------------------------------------------------
function generateGhostQuads(atlas)
    local quads = {}
    for x = 0, 96, 32 do
        quads[1+#quads] = love.graphics.newQuad(x, 0, 32, 32,atlas:getDimensions())
    end
    return quads
end

function generateGemQuads(atlas,tile_size)
    local quads = {}
    local w = 5 * tile_size
    for x = 0, w, tile_size do
        quads[1+#quads] = love.graphics.newQuad(x, 0, tile_size, tile_size, atlas:getDimensions())
    end
    return quads
end