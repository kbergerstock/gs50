--- sign.lua
-- k.r.bergerstock  @ 8/18
-- returns the sign function of a number

    function sign(d)
        if d < 0 then
            return -1
        elseif d > 0 then
            return 1
        else
            return 0
        end
    end
