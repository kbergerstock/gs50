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
require 'lib/StateMachine'
require 'lib/handy'
require 'lib/HighScoreTracker'
require 'lib/loveTimer'

--
-- the application code
require 'src/loadResources'
require 'src/init_message'
--
-- utility
require 'src/Util'
require 'src/states/threads'
require 'src/states/handle_mouse'
-- game pieces
require 'src/Board'
require 'src/Tile'
require 'src/ghost'

-- game states
require 'src/states/baseAppState'
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/StartState'