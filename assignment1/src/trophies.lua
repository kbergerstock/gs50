-- trophies.class
-- krbergerstock 2019.09.06
-- used to display the trophies on thee final score screen

-- luacheck: allow_defined,no unused
-- luacheck: globals love Class
-- luacheck: globals WINDOW_WIDTH WINDOW_HEIGHT VIRTUAL_WIDTH VIRTUAL_HEIGHT

Trophies = Class{}

function Trophies:init()
    self.images = {}
    self.images[1] = love.graphics.newImage('img/pawn.png')
    self.images[2] = love.graphics.newImage('img/knight.png')
    self.images[3] = love.graphics.newImage('img/rook.png')
    self.images[4] = love.graphics.newImage('img/king.png')

    self.x = VIRTUAL_WIDTH / 2 - 19
    self.y = 20
end


function Trophies:render(trophy)
    if trophy > 0 and trophy <= 4 then
        local image = self.images[trophy]
        love.graphics.draw(image, self.x, self.y)
    end
end
