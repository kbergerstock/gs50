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

PlayState = Class{__includes = BaseState}
   
-- constructor
function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0          -- timer acumulator got timer
    self.alarm = 2          -- alarm to control whrn new pipes should be added KRB
    self.score = 0
    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = 0
    -- scrolling = false
    self.paused = false
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter(params)
    if not self.paused then
        self.bird:reset() 
        self.timer = 0
        self.score = 0
        -- initialize our last recorded Y value for a gap placement to base other gaps off of
        self.lastY = -PIPE_HEIGHT + math.random(80) + 20    
    end
    SCROLLING = true
    self.paused = false
end
-- check y boundries. y is negitive at this point and represents the top pipe
function PlayState:checkBoundries(y)
    return math.max(-PIPE_HEIGHT + 10, math.min( y , VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT) )
end 

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.timer = self.timer + dt

    -- spawn a new pipe pair every second and a half
    if self.timer > self.alarm then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = checkBoundries(self.lastY + math.random(-20, 20))

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y))
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
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
                if self.score == 10 or self.score == 20 then
                    -- shorten the distance between the pipes
                    GAP_LEVEL = GAP_LEVEL - 5
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
                sounds['explosion']:play()
                sounds['hurt']:play()
                return { state = 'score', score = self.score }
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)
    -- new feature found the bird can fly over the top of pipes - seems there is no upper bound check
    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()
        return { state = 'score', score = self.score }
    end

    -- change to pause state if key 'P' is deceted
    if love.keyboard.wasPressed('p') or love.keyboard.wasPressed('P') then
        self.paused = true
        return { state = 'pause', pause = true}
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('SCORE: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    if not self.paused then
        -- clean up memory used to store pipe data
        for k, pair in pairs(self.pipePairs) do
            table.remove(self.pipePairs, k)
        end
        self.pipePairs = {}
    end
    -- stop scrolling for the death/score screen
    SCROLLING = false
end