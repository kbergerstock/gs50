--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

-- luacheck: allow_defined, globals Class setColor love gFrames gTextures

Tile = Class{}

function Tile:init(col, row, color, variety)

    -- using a little chess knowledge the board is being changed to a 10 by 10
    -- this will make the search more efficient krb
    -- board positions  ndx = (row -1) * 10 + col formula to obtain indice for tile list
    self.COL = col
    self.ROW = row

    -- screen coordinate positions
    -- the board is oreintated so that the fisrt tile is in
    -- bottom left corner of the screen
    -- and the last tile is in the upper right
    self.x = (col - 2) * 32
    self.y = (9 - row) * 32
    self.w = self.y

    -- tile appearance/points
    self.color = color
    self.variety = variety
    -- with 18 colors amd 6 variety's there are 108 unique pieces
    self.piece = color * 10 + variety
    self.matched = self.piece
    self.bomb = false                   -- bomb mode == true
    self.hilite  = false                -- true if hilite
end

function Tile:render(x, y, tick)
    if self.matched > 0 then
        if self.w > self.y then
            self.y = self.y + 4
        elseif self.y >= self.w then
            self.y = self.w
        end

        -- draw shadow
        love.graphics.setLineWidth(1)
        setColor(34, 32, 52, 255)
        love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
            self.x + x + 2, self.y + y + 2)

        -- draw tile itself
        setColor(255, 255, 255, 255)
        love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],self.x + x, self.y + y)
        if self.w > self.y then
            self.y = self.y + 2
        else
            self.y = self.w
        end
        if (self.hilite or self.bomb) and tick then
            -- multiply so drawing white rect makes it brighter
            love.graphics.setBlendMode('add')
            if self.bomb then
                setColor(200,158 ,148,32)
            else
                setColor(255, 255, 255, 96)
            end
            love.graphics.rectangle('fill', (self.x + x),(self.y + y), 32, 32, 4)
            -- back to alpha
            love.graphics.setBlendMode('alpha')
        end
    elseif self.matched < 0 then
        setColor(0,0,0,0)
        love.graphics.rectangle('fill', (self.x + x),(self.y + y), 32, 32, 4)
    end
end