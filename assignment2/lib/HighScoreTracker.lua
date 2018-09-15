--[[
    high score tracking class
    k.r.bergerstock
]]

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

HighScoreTracker = Class{}

function HighScoreTracker:init(maxScores)
    self.mx = maxScores or 12 
    self.fileTable = {}
    self.highScores = {}
    self.fileName = ''
    self.gName = ''
end

function HighScoreTracker:initialize(gn)
    self.gName = gn or 'luaSaved'
    love.filesystem.setIdentity(gn)
    self.fileName = gn .. '.lst'
    self.highScores = {}
    self.fileTable = {}
end

--[[
    Loads high scores from a .lst file, saved in LÖVE2D's default save directory in a subfolder
    called 'breakout'.
]]
function HighScoreTracker:loadHighScores(gName)
    self:initialize(gName)
    -- if the file doesn't exist, initialize it with some default scores
    self.fileTable = love.filesystem.getInfo(self.fileName, self.fileTable)
    if not self.fileTable then
        self.highScores['count'] = self.mx
        for i = 1, self.mx, 1 do
            self.highScores[i]= {name = 'CTO', score = i*1000}
        end
        self.highScores = self:sort(self.highScores)
        return self:writeScores()
    else
        return self:readHighScores()        
    end
end

-- sorts highScore list so high score is first element
function HighScoreTracker:sort(hs)
    local l = self.highScores['count']
    for i = 1 ,l - 1 ,1 do
        for j = l , i+1, -1 do
            if hs[j].score > hs[i].score then
                hs[i], hs[j] = hs[j], hs[i] 
            end
        end
    end
    return self.highScores
end

-- add a new score to the bottom of the list
-- sort the list high score to low score
-- remove the list bottom : keeps the list from growing
function HighScoreTracker:add(cName,cScore)
    self.highScores.count = self.highScores.count + 1
    table.insert(self.highScores,{name = cName, score = cScore})
    self.highScores = self:sort(self.highScores)
    if self.highScores.count > self.mx then
        table.remove(self.highScores)
        self.highScores.count = self.highScores.count - 1     
    end    
end

-- retrieve the latest rendition of the list
function HighScoreTracker:get()
    return self.highScores
end

-- retuns true if given score belons on the list otherwise false
-- given that the list is sorted we only need to check the score 
-- afainst the bottom of the list
function  HighScoreTracker:checkScore(score)
    ndx = self.highScores.count
    item = self.highScores[ndx]
    return score > item.score
end

-- write scores to file
function HighScoreTracker:writeHighScores()
    local n = self.highScores.count
    lines = 'count = ' .. tostring(n) .. '\n'
    for i = 1, n , 1 do
        item = self.highScores[i]
        lines = lines .. 'name = ' .. item.name ..', score = ' .. tostring(item.score) .. '\n'
    end
    local s
    local m
    s , m = love.filesystem.write(self.fileName,lines)
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
    lines , size = love.filesystem.read(self.fileName)
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
        self.highScores = {}
        k1, k2, count = string.find(lines,m)
        self.highScores.count = tonumber(count)
        for i = 1, self.highScores.count, 1 do
            -- by using the k2 value to start a new search at
            -- we scan though the file getting all elements
            k1, k2, cName = string.find(lines, w, k2)
            k1, k2, cScore = string.find(lines, s, k2 + 1)
            table.insert(self.highScores,{name = cName, score = tonumber(cScore)})    
        end
        return 'success'
    end        
end