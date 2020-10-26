-- collision detection using bounding boxes
-- luacheck: globals Class BBox

require 'lib/class'
BBox = Class{}

function BBox:init()
    self.Left = 0
    self.Bottom = 0
    self.Right = 0
    self.Top = 0
end

function BBox:setBox(left, bottom, width, height)
    self.Left = left
    self.Bottom = bottom
    self.Right = left + width - 1
    self.Top = bottom + height - 1
end

function BBox:collides( bbox )
    return ( self.Left > bbox.Right or bbox.Left > self.Right or
        self.Top > bbox.Bottom or bbox.Top > self.Bottom )
end


