--[[
    high score tracking class
    k.r.bergerstock
]]

-- luacheck: allow_defined, no unused, globals Class setColor love BaseState o
-- luacheck: globals VIRTUAL_WIDTH VIRTUAL_HEIGHT WINDOW_WIDTH WINDOW_HEIGHT

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

HighScoreTracker = Class{}

function HighScoreTracker:init(maxScores)
    self.mx_ = maxScores or 12
    self.fileTable_ = {}
    self.highScores_ = {}
    self.fileName_ = ''
    self.gName = ''
end

function HighScoreTracker:initialize(gn)
    self.gName = gn or 'luaSaved'
    love.filesystem.setIdentity(gn)
    self.fileName_ = gn .. '.lst'
    self.highScores_ = {}
    self.fileTable_ = {}
end

--[[
    Loads high scores from a .lst file, saved in LÖVE2D's default save directory in a subfolder
    called 'breakout'.
]]
function HighScoreTracker:loadHighScores(gName)
    self:initialize(gName)
    -- if the file doesn't exist, initialize it with some default scores
    self.fileTable_ = love.filesystem.getInfo(self.fileName_, self.fileTable_)
    if not self.fileTable_ then
        self.highScores_['count'] = self.mx_
        for i = 1, self.mx_, 1 do
            self.highScores_[i]= {name = 'CTO', score = i*100}
        end
        self.highScores_ = self:sort(self.highScores_)
        return self:writeHighScores()
    else
        return self:readHighScores()
    end
end

-- sorts highScore list so high score is first element
function HighScoreTracker:sort(hs)
    local l = #hs
    for i = 1 ,l - 1 ,1 do
        for j = l , i+1, -1 do
            if hs[j].score > hs[i].score then
                hs[i], hs[j] = hs[j], hs[i]
            end
        end
    end
    return hs
end

-- add a new score to the bottom of the list
-- sort the list high score to low score
-- remove the list bottom : keeps the list from growing
function HighScoreTracker:add(cName,cScore)
    self.highScores_.count = self.highScores_.count + 1
    table.insert(self.highScores_,{name = cName, score = cScore})
    self.highScores_ = self:sort(self.highScores_)
    if self.highScores_.count > self.mx_ then
        table.remove(self.highScores_)
        self.highScores_.count = self.highScores_.count - 1
    end
end

-- retrieve the latest rendition of the list
function HighScoreTracker:get()
    return self.highScores_
end

-- retuns true if given score belons on the list otherwise false
-- given that the list is sorted we only need to check the score
-- afainst the bottom of the list
function  HighScoreTracker:checkScore(score)
    ndx = self.highScores_.count
    item = self.highScores_[ndx]
    return score > item.score
end

-- write scores to file
function HighScoreTracker:writeHighScores()
    local n = self.highScores_.count
    lines = 'count = ' .. tostring(n) .. '\n'
    for i = 1, n , 1 do
        item = self.highScores_[i]
        lines = lines .. 'name = ' .. item.name ..', score = ' .. tostring(item.score) .. '\n'
    end
    local s
    local m
    s , m = love.filesystem.write(self.fileName_,lines)
    if s then m = 'success' end
    return m
end

--read scores from a file
function HighScoreTracker:readHighScores()
    local lines = ''
    local size = 0
    local m = 'count = (%d+)'
    local w = 'name = (%w+)'
    local s = 'score = (%d+)'
    lines , size = love.filesystem.read(self.fileName_)
    if not lines and true then
        -- if lines is nil, size holds the error msg
        return size
    else
        -- parse the list using pattern matching
        local k1    -- start index value where match was located
        local k2    -- end index values wher match was located
        local count
        local cName
        local cScore
        self.highScores_ = {}
        k1, k2, count = string.find(lines,m)
        self.highScores_.count = tonumber(count)
        for i = 1, self.highScores_.count, 1 do
            -- by using the k2 value to start a new search at
            -- we scan though the file getting all elements
            k1, k2, cName = string.find(lines, w, k2)
            k1, k2, cScore = string.find(lines, s, k2 + 1)
            table.insert(self.highScores_,{name = cName, score = tonumber(cScore)})
        end
        return 'success'
    end
end

function HighScoreTracker:render(x, y, font)
    local width = 190
    local heigth = 176

    -- high score text
    setColor(56, 56, 56, 234)
    love.graphics.rectangle('fill', x,y, width, heigth, 6, 4)
    setColor(155, 96, 255, 255)

    -- iterate over all high score indices in our high scores table
    local xs = x + 4
    local ys = y + 4
    love.graphics.setFont(font)
    love.graphics.printf('High Scores', xs, ys, width, 'center')
    ys = ys + 18
    for i = 1, self.mx_ do
        local name = self.highScores_[i].name or '---'
        local score = self.highScores_[i].score or '---'

        -- score number (1-10)
        love.graphics.printf(tostring(i) .. '.', xs, ys, 30, 'left' )
        -- score name
        love.graphics.printf(name, xs + 30 , ys, 30, 'right')
        -- score itself
        love.graphics.printf(tostring(score), xs +62 , ys, 100, 'right')
        ys = ys + 14
    end
end