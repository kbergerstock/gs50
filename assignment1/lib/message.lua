-- message packet
-- k.r.bergerstock 2018.09.06 / 2019.01.22 new idea to encapsulate the state data
-- Message is a closure based object

-- luacheck: globals Message BaseState

 function Message()
    -- predefine variables required by the app and statemachine engine
    local self =   {
                        states = {},
                        fonts = {},
                        sounds = {},
                        score = 0,
                        level = 0,
                        health = 3,
                        scrolling = false,
    }
    -- declaring __current, __next local , limits access
    -- ensure there is a blank idle state that the engine starts from
    local __current = '__idle'
    local __next = '__idle'
    self.states[__current]  = BaseState()

    -- set the next state to active
    function  self.Change(state)
        __next = state
    end
    -- get next state
    function self.getNext()
        return  __next
    end
    -- get current state
    function self.getCurrent()
        return __current
    end
    -- actually make the next state active
    function self.advanceState()
        __current = __next
    end

    return self
end
