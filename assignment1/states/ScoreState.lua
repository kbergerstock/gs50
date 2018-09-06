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

function ScoreState:render(msg)
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    local usr_msg = 'OOF! YOU LOST!'
    -- the offset of three is to allow for the 2-3 pipes 
    -- that were already on the screen to pass by before the gap change is observed
    if msg.score > 62.5 then
        usr_msg = ' I GIVE UP, YOU ARE TOO GOOD, I AM CRAWLING BACK IN MY DIMENSIONAL HOLE'
    elseif msg.score > 32.5 then  -- gap width avg 92.5
        usr_msg = 'YOU ARE A MASTER AT THIS GAME '
    elseif msg.score > 22.5 then -- gap witdh avg = 95
        usr_msg = 'EXPERT LEVEL COMPLETE : EXCELLANT'
    elseif msg.score > 12.5 then -- gap width avg = 97.5
        usr_msg = 'BEGINNER LEVEL COMPLETE : GOOD GOING'
    end

    love.graphics.printf(usr_msg, 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('SCORE: ' .. tostring(msg.score), 0, 120, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('PRESS SPACE TO PLAY AGAIN!', 0, 160, VIRTUAL_WIDTH, 'center')
end