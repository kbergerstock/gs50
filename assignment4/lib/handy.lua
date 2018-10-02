-- handy snippts and conversions
-- k.r.bergerstock


-- setcolor
-- krb
-- function converts color calls from love2d 10 -> love2d 11

-- luacheck: ignore setColor, globals love, no unused

function setColor(r,g,b,a)
    local t = type(r)
    local red = 0
    local green = 0
    local blue  = 0
    local alpha = 0
    if t == 'number' then
        red = r / 255.0
        green = g / 255.0
        blue = b / 255.0
        alpha = a / 255.0
    elseif t == 'table' then
        red = r[1] / 255.0
        green = r[2] / 255.0
        blue = r[3] /255.0
        alpha = r[4] / 255.0
    else
        return
    end
    love.graphics.setColor(red, green, blue, alpha)
end