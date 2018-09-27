-- fade.lua
-- k.r.bergerstock

-- luacheck: allow_defined, no unused
-- luacheck: globals love
-- luacheck: ignore updateBoard fade updateColorBank countdown wrap7 move_label

local EXTRA_TIME = 0
-- thread
function updateBoard(msg, action)
    local ms = 0        -- matches found
    local sf = 0        -- current board score
    local et = 0
    repeat
        if msg.board.match_found then
            while msg.board.match_found do
                ms, sf  = msg.board:calculateTileMatches()
                msg.score = msg.score + sf
                et = et + ms * 2
                if EXTRA_TIME == 0 then
                    EXTRA_TIME = et
                    et = 0
                end
                msg.board:updateRow()
                coroutine.yield()
                ms = 0
                sf = 0
                msg.board.match_found = (msg.board:doesTileMatchExist() > 0) and true or false
            end
        else
            coroutine.yield()
        end
    until action == 99
end

-- thread routine
function fade(direction)
    -- used to animate our full-screen transition rect
    -- transition to max alpha in 480 ms using 16 ms steps
    -- this matches roughly a change per frame at 60FPS
    local st = 0
    local et = 0
    local alpha = direction > 0 and 0.0 or 1.0
    local step = direction > 0 and 1 or -1
    local si = step > 0 and 1 or 60
    local ei = step > 0 and 60 or 1
    for i = si, ei, step do
        st = love.timer.getTime()
        repeat
            coroutine.yield( false, alpha)  -- returns true,false,alpha
            et = love.timer.getTime()
        until (et - st) * 1000 > 16         -- 1000 ms / 60 fps = 16.67
        alpha = i * .01667                  -- 1.0 / 60 == max alpha / no steps
    end
    return true, alpha > 0.5 and 1.0 or 0.0
end

-- thread routine
function updateColorBank(action)
    -- used select the colors to display 'match3'
    local colorBank = 0
    local et = 0
    local st = 0
    st = love.timer.getTime()
    repeat
        repeat
            coroutine.yield(colorBank)
            et = love.timer.getTime()
        until (et - st) * 1000 > 500
        st = et
        colorBank = colorBank + 1
        if colorBank > 6 then
            colorBank = 0
        end
    until action == 99
end

-- thread routine
function move_label()
    local y = -64
    local et = 0
    local st = 0
    local lt = 0
    local wt = 0
    local dy = 0

    st = love.timer.getTime()
    lt = st
    for phase = 1 , 3 do
        if phase == 1 then
            wt = 246
            vt = 16
            dy = 13
        elseif phase == 2 then
            wt = 975
            dy = 0
            vt = 50
        else
            wt = 246
            vt = 16
            dy = 13
        end

        repeat
            repeat
            coroutine.yield(false, y)
            et = love.timer.getTime()
            until (et-st) * 1000 > vt
            y = y + dy
            st = et
        until (et - lt) * 1000 > wt
        lt = et
    end
    return true, y
end

-- thread routine
function countdown(seconds)
    local et = 0
    local lt = 0
    local wt = 0
    local tick = false
    local allowed_time = seconds
    lt = love.timer.getTime()
    wt = lt
    repeat
        repeat
            repeat
                coroutine.yield(false, tick, allowed_time)
                allowed_time  = allowed_time  + EXTRA_TIME
                EXTRA_TIME = 0
                et = love.timer.getTime()
            until (et - lt) * 1000 > 499
            lt = et
            tick = not tick
        until (et - wt) * 1000 > 997
        wt = et
        allowed_time  = allowed_time - 1
    until allowed_time < 0
    return true, tick, 0
end

function wrap7(v)
    local r
    if v < 0 then
        r = 7
    elseif v > 7 then
        r = 0
    else
        r = v
    end
    return r
end