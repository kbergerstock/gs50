-- bomb.lua
-- bomb sprites

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor gRSC
-- luacheck: ignore renderBomb generateBombQuads


function renderBomb(x, y)
    local sx = x + 8
    local sy = y + 8
    setColor(255,255,255,96)
    love.graphics.draw(gRSC.textures['bombs'], gRSC.frames['bombs'][1],sx, sy)
end

--------------------------------------------------------
function generateBombQuads(atlas)
    local quads = {}
    quads[1] = love.graphics.newQuad(0, 32, 16, 16,atlas:getDimensions())
    quads[2] = love.graphics.newQuad(0,  0, 16, 16,atlas:getDimensions())
    quads[3] = love.graphics.newQuad(0, 32, 32, 32,atlas:getDimensions())
    quads[4] = love.graphics.newQuad(72, 8, 48, 48,atlas:getDimensions())
    return quads
end