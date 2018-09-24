--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

-- luacheck: allow_defined, globals Class setColor love Tile

-- helper functions
function __compare(c,cc)
    for i = 1, #cc do
        if (cc[i] == c) then
            return true
        end
    end
    return false
end

function __create_color_table()
    local cc = {}
    local c = math.random(18)
    local k = 2
    cc[1] = c
    repeat
        c = math.random(18)
        if not __compare(c,cc) then
            cc[k] = c
            k = k + 1
        end
    until k == 7
    return cc
 end

 -----------------------------------

Board = Class{}

function Board:init(x, y, level)
    -- this coordinate is for the upper left corner of the board
    self.x = x
    self.y = y
    self.colors = {}        -- an arrary of the 6 pieces used in this board
    self.ndx = 0            -- index of current tile hilite
    self.match_found = false
    self.swaps = ''
    -- generate the colors we need for this board
    if level == 1 then
        self.colors = {1,4,7,10,13,16 }
    elseif level == 2 then
        self.colors = {2,5,8,11,14,17 }
    elseif level == 3 then
        self.colors = {3,5,9,12,15,18 }
    else
        self.colors = __create_color_table()
    end
    -- and lastly !! create the board for this level
    self:initializeTiles()
end

function Board:initializeTiles()
    repeat
        self.tiles = {}
        local row = 1           -- bottom left corner
        local col = 1           -- ndx = (row - 1) * 10 + col
        -- generate the board
        for i = 1,100 do
            if row == 1 or row == 10 or col == 1 or col == 10 then
                self.tiles[i] = Tile(col,row,0,0)
            else
                local p = math.random(6)
                local cc = self.colors[p]
                self.tiles[i] =  Tile(col, row, cc, p)
            end
            col = col + 1
            if col > 10 then
                col = 1
                row = row + 1
            end
        end
    until self:doesTileMatchExist() == 0      -- is true ie no matches found
end

-- by adding am empty square around the outside perimeter
-- it allowd us iterate / index over the board without checking for boundries
function Board:doesTileMatchExist()
    for i = 11, 90 do
        local p0 = self.tiles[i].piece
        if p0 > 0 then
            local p1 = self.tiles[i+1].piece
            local p3 = self.tiles[i-1].piece
            local p5 = self.tiles[i+10].piece
            local p7 = self.tiles[i-10].piece
            if (p0 == p1 and p0 == p3) or (p0 == p5 and p0 == p7) then
                return 3
            end
        end
    end
    return 0
end

-- the row ,col coordinates here are 0,0  based so formula is slightly different
function Board:toggleTile(col,row)
    local idx = (row + 1) * 10 + col + 2

    if self.ndx > 0 then
        local ddx = idx - self.ndx
        if (ddx == 1 or ddx == -1 or ddx == 10 or ddx == -10)  then
            self.tiles[self.ndx].hilite = false
            self:swap(idx,self.ndx)
            if self:doesTileMatchExist() > 0 then
                self.ndx = 0
                self.match_found = true
            else
                self:swap(idx,self.ndx)
            end
        else
            self.tiles[self.ndx].hilite = false
            self.ndx = idx
            self.tiles[self.ndx].hilite = true
        end
    else
        self.ndx = idx
        self.tiles[self.ndx].hilite = true
    end
end

function Board:set(idx, tile)
    -- assert(idx ~= nil,'error idx is nil')
    -- self:addSwaps(idx,999)
    self.tiles[idx].piece  = tile.piece
    self.tiles[idx].color  = tile.color
    self.tiles[idx].variety = tile.variety
    self.tiles[idx].matched = tile.matched
end

function Board:swap(idx,jdx)
    -- assert(jdx ~= nil,'error jdx is nil')
    -- assert(idx ~= nil,'error idx is nil')
    -- self:addSwaps(idx,jdx)
    local piece = self.tiles[idx].piece
    local color = self.tiles[idx].color
    local variety = self.tiles[idx].variety
    local matched = self.tiles[idx].matched
    self.tiles[idx].piece  = self.tiles[jdx].piece
    self.tiles[idx].color  = self.tiles[jdx].color
    self.tiles[idx].variety = self.tiles[jdx].variety
    self.tiles[idx].varoety = self.tiles[jdx].matched
    self.tiles[jdx].piece  = piece
    self.tiles[jdx].color  = color
    self.tiles[jdx].variety = variety
    self.tiles[jdx].matched = matched
end

function Board:render(tick)
    for i = 11 , 90 do
        -- this fumction is being passed the upper right corner as the origin
        -- the render function will transcribe this to the lower left
        self.tiles[i]:render(self.x, self.y ,tick)
    end
end

-- by adding am empty square around the outside perimeter
-- it allowd us iterate / index over the board without checking for boundries
function Board:calculateTileMatches()
    local matches = 0
    for i = 11, 90 do
        local p0 = self.tiles[i].piece
        if p0 > 0 then
            local p1 = self.tiles[i+1].piece
            local p3 = self.tiles[i-1].piece
            local p5 = self.tiles[i+10].piece
            local p7 = self.tiles[i-10].piece

            if p0 == p1 and p0 == p3 then
                self.tiles[i].matched = -1
                self.tiles[i+1].matched = -1
                self.tiles[i-1].matched = -1
                matches = matches + 1
            end

            if p0 == p5 and p0 == p7 then
                self.tiles[i].matched = -1
                self.tiles[i+10].matched = -1
                self.tiles[i-10].matched = -1
                matches = matches + 1
            end
        end
    end
    return matches
end

-- debug routine
function Board:addSwaps(idx,jdx)
    self.swaps = self.swaps .. 'from : ' .. tostring(jdx) .. " to -> " .. tostring(idx) ..'\n'
end

function Board:fillBlank(jdx)
    if jdx > 81 and jdx < 90 then
        local p = math.random(6)
        local tile = Tile(0,0,self.colors[p],p)
        self:set(jdx, tile)
    end
end

function Board:dropColumn(jdx)
    -- at this point jdx should be the topmost empty hole in the column
    -- move everthing down one tile
    local kdx = jdx + 10
    repeat
        self:swap(kdx, jdx)
        self.tiles[jdx].y = self.tiles[kdx].y
        jdx = jdx + 10
        kdx = kdx + 10
    until jdx > 80
    self:fillBlank(jdx)
end

-- eliinate marked tiles
-- fill in holes from tiles above hole
-- add in new tiles as required
-- this routine runs top to bottom on a column

function Board:updateRow()
    local idx = 11
    repeat
        -- find an empty hole fill it
        -- -1 is a deleted tile
        --  0 is a order tile
        --  positive number > 0 is a piece
        local jdx = idx + 60            -- row seven
        local kdx = idx + 70            -- row 8
        repeat
            if self.tiles[kdx].matched < 0  then
                self:fillBlank(kdx)
            end
            if self.tiles[jdx].matched < 0 then
                self:dropColumn(jdx)
            end
            jdx = jdx - 10
        until jdx < idx
        idx = idx + 1
    until idx > 20
end