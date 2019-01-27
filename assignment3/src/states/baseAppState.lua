-- luacheck: allow_defined,no unused
-- luacheck: globals love Class BaseState gRSC

baseAppState = Class{__includes = BaseState}

function baseAppState:_init_()
    self.VW = gRSC.W.VIRTUAL_WIDTH
    self.VH = gRSC.W.VIRTUAL_HEIGHT
    -- self.inputs = Inputs()
end
-- default functions used if not declared by derived class
function baseAppState:init() self:_init_() end

function baseAppState:handleInputs(input, msg)
    -- self.inputs:set(input)
end

function baseAppState:enter(msg)
    -- self.inputs:reset()
end
-- joystick input is commented out