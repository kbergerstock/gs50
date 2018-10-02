--[[
    GD50
    Super Mario Bros. Remake

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Some global constants for our application.
]]


-- luacheck: allow_defined, no unused
-- luacheck: ignore VIRTUAL_WIDTH VIRTUAL_HEIGHT WINDOW_WIDTH WINDOW_HEIGHT
-- these must stay here because they are used by push in main

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144