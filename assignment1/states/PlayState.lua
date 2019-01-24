--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.

`   removed dependency on gStateMachine global variable   07/15/2018 KRB
    added varaible (alarm) and  code to impement random spacing between pipe pairs    07/15/2018 KRB
]]

-- luacheck: allow_defined,no unused
-- luacheck: globals love Class BaseState Bird PipePair
-- luacheck: globals WINDOW_WIDTH WINDOW_HEIGHT VIRTUAL_WIDTH VIRTUAL_HEIGHT
-- luacheck: globals PIPE_SPEED PIPE_WIDTH PIPE_HEIGHT
-- luacheck: globals BIRD_WIDTH BIRD_HEIGHT COUNTDOWN_TIME

PlayState = Class{__includes = BaseState}

-- constructor
function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0          -- timer acumulator got timer
    self.alarm = 2          -- alarm to control whrn new pipes should be added KRB
    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = 0
    self.gap = 15
    self.paused = false
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter(msg)
    self.bird:reset()
    msg.score = 0
    self.timer = 0
    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    self.gap = 15
    msg.scrolling = true
    self.paused = false
end

function PlayState:handleInput(input, msg)
    -- toggle pause state if key 'P' is decteted
    if input == 'P' or input == 'p' or false then
        self.paused = not self.paused
        if self.paused then
            msg.sounds['music']:stop()
            msg.sounds['music']:setLooping(false)
            msg.sounds['pause']:setLooping(true)
            msg.sounds['pause']:play()
        else
            msg.sounds['pause']:stop()
            msg.sounds['pause']:setLooping(false)
            msg.sounds['music']:setLooping(true)
            msg.sounds['music']:play()
        end
    else
        msg.user:set(input)
    end
end

function PlayState:update(msg, dt)

    if self.paused then
        return nil
    end

    -- update timer for pipe spawning
    self.timer = self.timer + dt
    scrollBackground(dt)
    -- spawn a new pipe pair every second and a half
    if self.timer > self.alarm then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = checkBoundries(self.lastY + math.random(-20, 20))

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y, self.gap))
        self.lasty = y
        -- reset timer
        self.timer = 0
        -- set up the alarm interval meed to wait befor drawing the pipes
        -- increase the resoltion of the alarm so it looks continous rather than discreete KRB
        self.alarm = math.random(175,275) / 100.0
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                msg.score = msg.score + 1
                pair.scored = true
                msg.sounds['score']:play()
                if msg.score == 10 or msg.score == 20 or msg.score == 43 then
                    -- shorten the distance between the pipes
                   self.gap = self.gap - 5
                    -- allow a longer time between levels
                    self.alarm = 3.5
                end
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                msg.sounds['explosion']:play()
                msg.sounds['hurt']:play()
                msg.nextState('score')
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(msg, dt)
    -- new feature found the bird can fly over the top of pipes - seems there is no upper bound check
    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        msg.sounds['explosion']:play()
        msg.sounds['hurt']:play()
        msg.nextState('score')
    end

end

function PlayState:render(msg)
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(msg.fonts['flappy'])
    love.graphics.print('SCORE: ' .. tostring(msg.score), 8, 8)

    self.bird:render()

    if self.paused then    love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setFont(msg.fonts['flappy'])
        love.graphics.printf('GAME PAUSED', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(msg.fonts['medium'])
        love.graphics.printf('PRESS P TO EXIT',0,100,VIRTUAL_WIDTH, 'center')
    end
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit(msg)
    -- clean up memory used to store pipe data
    for k, pair in pairs(self.pipePairs) do
        table.remove(self.pipePairs, k)
    end
    self.pipePairs = {}

    -- stop scrolling for the death/score screen
    msg.SCROLLING = false
end
