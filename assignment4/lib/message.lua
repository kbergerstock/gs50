-- message packet
-- enforces proper state change
-- and passes object data bewteen state functions
-- k.r.bergerstock 2018.09.06
-- Message is a closure based object

-- luacheck: ignore Message

 function Message(start)

    local self =   {
                        score = 0,
                        level = 0,
                        health = 3,
    }

    local next = 'idle'

    function  self.nextState(state)
        next = state
    end

    function self.next()
        return next
    end

    return self
end