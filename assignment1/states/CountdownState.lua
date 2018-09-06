--[[
    Countdown State
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin. Transitions to the PlayState as soon as the
    countdown is complete.
    
    removed dependency on gStateMachine global variable   07/15/2018 KRB
]]


CountdownState = Class{__includes = BaseState}

function CountdownState:init()
    self.count = 0
    self.timer = 0
end

function CountdownState:enter()
    self.count = 3
    self.timer = 0
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]
function CountdownState:update(inputs,msg,dt)
    self.timer = self.timer + dt

    -- loop timer back to 0 (plus however far past COUNTDOWN_TIME we've gone)
    -- and decrement the counter once we've gone past the countdown time
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        -- when 0 is reached, we should enter the PlayState
        if self.count == 0 then
             --msg.next  = 'play'
             msg.score = msg.score + 7
             msg.next = 'score'
        end
    end
end

function CountdownState:render()
    -- render count big in the middle of the screen
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end