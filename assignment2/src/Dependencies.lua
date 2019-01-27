-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'lib/push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'lib/Inputs'
require 'lib/StateMachine'
require 'lib/HighScoreTracker'
require 'lib/gamePad'

require 'src/init_message_packet'
-- a few global constants, centralized
require 'src/loadResources'
--  defines a target that interacts with the paddle or gricks (base class for ball and powerups)
require 'src/Target'

-- the ball that travels around, breaking bricks and triggering lives lost
require 'src/Ball'
require 'src/balls'

-- the entities in our game map that give us points when we collide with them
require 'src/Brick'
require 'src/bricks'

-- a class used to generate our brick layouts (levels)
require 'src/LevelMaker'

-- the rectangular entity the player controls, which deflects the ball
require 'src/Paddle'

-- pwerup sprites
require 'src/powerUp'
require 'src/PowerUps'

-- utility functions, mainly for splitting our sprite sheet into various Quads
-- of differing sizes for paddles, balls, bricks, etc.
require 'src/Util'

-- each of the individual states our game can be in at once; each state has
-- its own update and render methods that can be called by our state machine
-- each frame, to avoid bulky code in main.lua
require 'src/states/baseAppState'
require 'src/states/EnterHighScoreState'
require 'src/states/GameOverState'
require 'src/states/HighScoreState'
require 'src/states/PaddleSelectState'
require 'src/states/PlayState'
require 'src/states/ServeState'
require 'src/states/StartState'
require 'src/states/VictoryState'