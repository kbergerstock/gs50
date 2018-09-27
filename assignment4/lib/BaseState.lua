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

-- luacheck: globals BaseState Class o
-- luacheck: no unused args , no self

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end
BaseState = Class{}

function BaseState:init() end
function BaseState:enter(msg) end
function BaseState:exit(msg) end
function BaseState:update(inputs, msg, dt) end
function BaseState:render(msg) end
function BaseState:handle_input(input, msg) end
