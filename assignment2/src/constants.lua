--[[
    GD50 2018
    Breakout Remake

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Some global constants for our application.
]]

require 'lib/readonly'

function loadConstants()
    local constants = {}

    -- size of our actual window
    constants.WINDOW_WIDTH = 1280
    constants.WINDOW_HEIGHT = 720

    -- size we're trying to emulate with push
    constants.VIRTUAL_WIDTH = 432
    constants.VIRTUAL_HEIGHT = 243

    -- paddle movement speed
    constants.PADDLE_SPEED = 200

    gConst = readOnly(constants)
    assert(gConst,"error in creating constants")

end