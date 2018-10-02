-- K.R.Bergerstock 09/2018
-- total rewrite of Colton's code, main is now just boiler plate
-- along with a shell app class any project can be started, using the same main.lua fle

--[[
    GD50
    super Mario bros remake

    credit to : Colton Ogden
    cogden@cs50.harvard.edu

        A classic platformer in the style of Super Mario Bros., using a free
    art pack. Super Mario Bros. was instrumental in the resurgence of video
    games in the mid-80s, following the infamous crash shortly after the
    Atari age of the late 70s. The goal is to navigate various levels from
    a side perspective, where jumping onto enemies inflicts damage and
    jumping up into blocks typically breaks them or reveals a powerup.

    Art pack:
    https://opengameart.org/content/kenney-16x16

    Music:
    https://freesound.org/people/Sirkoto51/sounds/393818/

]]

require 'src/loadResources'

-- luacheck: allow_defined, no unused
-- luacheck: globals Message StateMachine cHID Class setColor love
-- luacheck: globals VIRTUAL_WIDTH VIRTUAL_HEIGHT
-- luacheck: globals gFonts gSounds LoadResources
-- luacheck: globals StartState PlayState

APP = Class{}

function APP:init()
    self.inputs = cHID()
    self.msg = Message()
end

function APP:load()
    -- assert(self.msg,'The resources are not loaded !')
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- window bar title
    love.graphics.setFont(gFonts['medium'])
    love.window.setTitle('Super 50 Bros.')

    self.gameStateMachine = StateMachine {
        ['start'] = StartState(),
        ['play']  = BaseState()  -- PlayState()
    }

    -- seed the RNG
    math.randomseed(os.time())

    self.msg.nextState('start')
end

function APP:handle_input(input, x, y)
    -- add to our table of keys pressed this frame
    if input == 'escape' then
        -- quit if the escape was detectd
        self:stop()
      else
        self.gameStateMachine:handle_input(input, self.msg)
    end
end

function APP:update(dt)

    self.gameStateMachine:update(self.inputs, self.msg, dt)

end

function APP:draw()
        -- render the current state
        self.gameStateMachine:render(self.msg)
end

function APP:loadResources()
    -- the resources and constants are stored in read only tables
    LoadResources()
    -- set music to loop and start
    gSounds['music']:setLooping(true)
    gSounds['music']:setVolume(0.5)
    gSounds['music']:play()
end

function APP:stop()
    gSounds['music']:stop()
    love.event.quit()
end
