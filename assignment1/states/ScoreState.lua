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
    GAP_LEVEL = 15
    self.trophies = Trophies()
    self.trophy = 0
end   

function ScoreState:exit()
    GAP_LEVEL = 15
end    

function ScoreState:update(inputs, msg,  dt)
    if inputs:isSpace() then
        if msg.score > 62.5 then
            love.event.quit(0)
        else
            msg.next = 'countdown'
        end
    end
end
function ScoreState:enter(msg)
    self.usr_msg = 'OOF! YOU LOST!'
    self.trophy = 0
    -- the offset of three is to allow for the 2-3 pipes 
    -- that were already on the screen to pass by before the gap change is observed
    if msg.score > 62.5 then
        self.usr_msg = ' I GIVE UP, YOU ARE TOO GOOD, I AM CRAWLING BACK INTO MY DIMENSIONAL HOLE'
        self.trophy = 4
    elseif msg.score > 32.5 then  -- gap width avg 92.5
        self.usr_msg = 'YOU ARE A MASTER AT THIS GAME '
        self.trophy = 3
    elseif msg.score > 22.5 then -- gap witdh avg = 95
        self.usr_msg = 'EXPERT LEVEL COMPLETE : EXCELLANT'
        self.trophy = 2
    elseif msg.score > 12.5 then -- gap width avg = 97.5
        self.usr_msg = 'BEGINNER LEVEL COMPLETE : GOOD GOING'
        self.trophy = 1
    end
end

function ScoreState:render(msg)
    -- simply render the score to the middle of the screen
    self.trophies:render(self.trophy)
    love.graphics.setFont(flappyFont)
    love.graphics.printf(self.usr_msg, 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('SCORE: ' .. tostring(msg.score), 0, 160, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('PRESS SPACE TO PLAY AGAIN!', 0, 180, VIRTUAL_WIDTH, 'center')
end