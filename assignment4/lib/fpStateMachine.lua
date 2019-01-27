-- luacheck: allow_defined, no unused
-- luacheck: ignore fpStateMachine

function fpStateMachine()
    local self = {
        Score = 0,
        Level = 0,
        Health = 3,
    }
    local _name =''
    local fp_current = nil
    local fp_next = nil

    function self.next(state)
        fp_next = state
    end

    function self.Name(name)
        _name = name
    end

    function self.name()
        return _name
    end

    function self.exec()
        if fp_next then
            fp_current = fp_next
            fp_next = nil
        end
        if fp_current then
            fp_current(self)
        end
    end
    function self.idle()
    end

    return self
end