-- mod.lua
-- k.r.bergerstock
-- performs modulus division
-- inputs an integer number and its divisor
-- output the quotent and remander
function mod(n, d)
    local function rd(n, d, q)
        if( n >= d) then
             return rd(n-d,d,q+1)
        else
            return q,n
        end
    end
    return rd(n,d,0)
end

function mod2(n,d)
    local r = n % d
    return (n-r)/d, r
end