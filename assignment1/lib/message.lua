-- message packet
-- k.r.bergerstock 2018.09.06 / 2019.01.22 new idea to encapsulate the state data
-- Message is a closure based object

-- luacheck: globals Message BaseState

 function Message()

    local self =   {
                        states = {},
                        fonts = {},
                        sounds = {},
                        score = 0,
                        level = 0,
                        health = 3,
                        scrolling = false,
    }

    local __current = '__idle'
    local __next = '__idle'
    self.states[__current]  = BaseState()

    function  self.nextState(state)
        __next = state
    end

    function self.next()
        return  __next
    end

    function self.current()
        return __current
    end

    function self.advanceState()
        __current = __next
    end

    return self
end
