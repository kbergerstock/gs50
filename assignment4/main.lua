-- simple start up code for a love2d engine
-- create an app Class to implement game
-- K. R. Bergerstock @ 09/2018

-- luacheck: allow_defined, no unused
-- luacheck: globals lclass push love APP LoadResources gRC


-- libraries
require 'lib/StateMachine'
require 'lib/handy'         -- setColor
require 'lib/dTimer'        -- digital timer input is dt
require 'lib/Log'
require 'lib/mod'
require 'lib/sign'
require 'lib/push'

-- utility
require 'src/Util'

-- game states
-- require 'src/states/game/PlayState'
-- require 'src/states/game/StartState'

-- entity states
-- require 'src/states/entity/pc_states'
-- require 'src/states/entity/npc_states'

-- game characters
-- require 'src/gc/Entity'
-- require 'src/gc/npc'
-- require 'src/gc/Player'
-- require 'src/gc/Snail'

-- general
-- require 'src/Animation'

-- require 'src/TileMap'
-- require 'src/GameObject'

-- require 'src/generateTileMap'
-- require 'src/generateNPCs'


-- require 'src/app'
require 'lvls/mapEditor'

function love.load()
    app = APP()
    app:run()
end