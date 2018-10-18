--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    -- Dependencies --

    A file to organize all of the global dependencies for our project, as
    well as the assets for our game, rather than pollute our main.lua file.
]]

-- luacheck: allow_defined, no unused
-- luacheck: ignore Class push

--
-- libraries
--
Class = require 'lib/class'
push = require 'lib/push'
require 'lib/BaseState'
require 'lib/StateMachine'
require 'lib/message'       -- packet messages
require 'lib/handy'         -- setColor
require 'lib/dTimer'        -- digital timer input is dt
--
-- our own code
--

-- utility
require 'src/constants'
require 'src/Util'

-- game states
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

-- entity states
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerWalkingState'

require 'src/states/entity/npc_states'

-- general
require 'src/game_pad'
require 'src/Animation'
require 'src/Entity'
require 'src/GameObject'
require 'src/generateTileMap'
require 'src/generateNPCs'
require 'src/Player'
require 'src/Snail'
require 'src/Tile'
require 'src/TileMap'