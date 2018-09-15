-- hamdle mouse
-- k.r.bergerstock
-- sept 2018

-- luacheck: allow_defined, no unused, globals Class setColor love BaseState
-- luacheck: ignore VIRTUAL_WIDTH VIRTUAL_HEIGHT WINDOW_WIDTH WINDOW_HEIGHT

-- thread routine
function handle_mouse_input(action)
    -- set the origin of the board
    local Ox = 240
    local Oy = 16
    local cx = 0
    local cy = 0
    local mx = 0
    local my = 0
    -- set the center point of the 0,0 square
    local sx = 240 + 16
    local sy = 272 - 16
    local bx = 0
    local by = 0
    local b1 = false
    local b2 = false
    local k1 = false
    local k2 = false
    local c1 = false
    local c2 = false
    love.mouse.setPosition(sx,sy)
    repeat
        -- mouse click detection
        b1 , b2 = love.mouse.isDown(1,2)
        if b1 then
            if not k1 then
                k1 = b1
            end
        else
            if k1 then
                c1 = k1
                k1 = b1
            end
         end
         if b2 then
            if not k2 then
                k2 = b2
            end
        else
            if k2 then
                c2 = k2
                k2 = b2
            end
        end

        mx , my = love.mouse.getPosition()
        -- scale the posisition to the virtual window
        mx = mx / 2.5
        my = my / 2.5
        -- if the position is withen the board limits
        -- cacluate the col, row  indice's and the center point of the piece
        if (mx > 240 and mx < 496 ) and (my > 16 and my < 272) then
            if mx > sx + 20 or mx < sx - 20 then
                cx = 0
                bx = Ox
                while bx + 32 < mx do
                    cx = cx + 1
                    bx = bx + 32
                end
                sx = bx + 16
            end
            -- this limit check makes sure that the mouse has moved off of the last position
            if my > sy + 20 or my < sy - 20 then
                cy = 0
                by = Oy
                while by + 32 < my do
                    cy = cy + 1
                    by = by + 32
                end
                sy = by + 16
            end
        end
        coroutine.yield( cx, 7-cy, sx, sy, c1, c2 )
        c1 = false
        c2 = false
    until action == 99
end
