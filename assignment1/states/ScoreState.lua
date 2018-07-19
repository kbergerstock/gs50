--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.

    removed dependency on gStateMachine global variable   07/15/2018 KRB
]]

ScoreState = Class{__includes = BaseState}

function ScoreState:init()
    self.score = 0
    GAP_LEVEL = 15
end   

function ScoreState:exit()
    self.score = 0
    GAP_LEVEL = 15
end    

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params['score']
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        r = {}
        r['state'] = 'countdown'
        return r
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    local msg = 'OOF! YOU LOST!'
    -- the offset of three is to allow for the 2-3 pipes 
    -- that were already on the screen to pass by before the gap change is oberved
    if self.score > 33 then  -- gao width avg 92.5
        msg = 'YOU ARE A MASTER AT THIS GAME '
    elseif self.score > 23 then -- gap witdh avg = 95
        msg = 'EXPERT LEVEL COMPLETE : EXCELLANT'
    elseif self.score > 13 then -- gap width avg = 97.5
        msg = 'BEGINNER LEVEL COMPLETE : GOOD GOING'
    end

    love.graphics.printf(msg, 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('SCORE: ' .. tostring(self.score), 0, 120, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('PRESS ENTER TO PLAY AGAIN!', 0, 160, VIRTUAL_WIDTH, 'center')
end