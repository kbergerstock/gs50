--[[
    GD50
    Breakout Remake

    -- BaseState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used as the base class for all of our states, so we don't have to
    define empty methods in each of them. StateMachine requires each
    State have a set of four "interface" methods that it can reliably call,
    so by inheriting from this base state, our State classes will all have
    at least empty versions of these methods even if we don't define them
    ourselves in the actual classes.
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals Class  BaseState gConst

BaseState = Class{}

function BaseState:init() self:_init_() end
function BaseState:enter(msgs) end
function BaseState:exit() end
function BaseState:update(msgs, dt) end
function BaseState:handleInput(input, msgs) end
function BaseState:render(msgs) end
function BaseState:_init_()
    self.VW = gConst.VIRTUAL_WIDTH
    self.VH = gConst.VIRTUAL_HEIGHT
end