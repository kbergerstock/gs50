--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    -- Dependencies --

    A file to organize all of the global dependencies for our project, as
    well as the assets for our game, rather than pollute our main.lua file.
]]

-- luacheck: allow_defined, no unused
-- luacheck: ignore Class push
-- luacheck: ignore VIRTUAL_WIDTH VIRTUAL_HEIGHT WINDOW_WIDTH WINDOW_HEIGHT
-- luacheck: ignore EXTRA_TIME
--
-- libraries
--
require 'lib/message'

Class = require 'lib/class'
push = require 'lib/push'
require 'lib/readonly'
require 'lib/BaseState'
require 'lib/StateMachine'
require 'lib/handy'
require 'lib/HighScoreTracker'

--
-- the application code
--
-- utility
require 'src/Util'
require 'src/states/threads'
require 'src/states/handle_mouse'
-- game pieces
require 'src/Board'
require 'src/Tile'
require 'src/bomb'

-- game states
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/StartState'

--
-- constants
function loadConstants()
    p = {}
    -- physical screen dimensions
    p.WINDOW_WIDTH = 1280
    p.WINDOW_HEIGHT = 720

    -- virtual resolution dimensions
    p.VIRTUAL_WIDTH = 512
    p.VIRTUAL_HEIGHT = 288
    gConst = readOnly(p)
end