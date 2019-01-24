--[[
    Countdown State
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin. Transitions to the PlayState as soon as the
    countdown is complete.

    removed dependency on gStateMachine global variable   07/15/2018 KRB
]]

-- luacheck: allow_defined,no unused
-- luacheck: globals love Class BaseState
-- luacheck: globals WINDOW_WIDTH WINDOW_HEIGHT VIRTUAL_WIDTH VIRTUAL_HEIGHT
-- luacheck: globals PIPE_SPEED PIPE_WIDTH PIPE_HEIGHT
-- luacheck: globals BIRD_WIDTH BIRD_HEIGHT COUNTDOWN_TIME

CountdownState = Class{__includes = BaseState}

function CountdownState:init()
    self.count = 0
    self.timer = 0
end

function CountdownState:enter(msg)
    self.count = 3
    self.timer = 0
    msg.scrolling = true
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]
function CountdownState:update(msg, dt)
    self.timer = self.timer + dt

    -- loop timer back to 0 (plus however far past COUNTDOWN_TIME we've gone)
    -- and decrement the counter once we've gone past the countdown time
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        -- when 0 is reached, we should enter the PlayState
        if self.count == 0 then
            msg.nextState('play')
        end
    end
end

function CountdownState:render(msg)
    -- render count big in the middle of the screen
    love.graphics.setFont(msg.fonts['huge'])
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end
