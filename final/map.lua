Class = require 'class'

Map = Class()

function Ma.init()
    -- map dimensions are given in tile size
    self.map_width = 48
    self.map_height = 24
    self.map = {}
end

function getTile(row,col)
    return map[(row * map_width + col +1)]
end