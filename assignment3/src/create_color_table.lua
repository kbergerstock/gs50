function __compare(c,cc)
    for i = 1, #cc do
        if (cc[i] == c) then
            return true
        end
    end
    return false
end

function create_color_table()
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
