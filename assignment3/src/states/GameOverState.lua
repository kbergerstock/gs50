--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    - GameOverState Class-

    State that simply shows us our score when we finally lose.
]]

-- luacheck: allow_defined, no unused, globals Class setColor love BaseState
-- luacheck: ignore VIRTUAL_WIDTH VIRTUAL_HEIGHT WINDOW_WIDTH WINDOW_HEIGHT

GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.highScores = HighScoreTracker(10)
    self.highScores:loadHighScores('match3')
end

function GameOverState:enter(msg)
    if self.highScores:checkScore(msg.score) then
        self.highScores:add('EVE',msg.score)
        self.highScores:writeHighScores()
    end
end

function GameOverState:handle_input(input, msg)
    -- switch to another state via one of the menu options
    if input == 'space' then
        msg.nextState('start')
    end
end

function GameOverState:render(msg)
    local w = 190
    local h = 66
    local xs = VIRTUAL_WIDTH / 2 - 64
    local ys =16
    love.graphics.setFont(gFonts['large'])

    setColor(56, 56, 56, 234)
    love.graphics.rectangle('fill',xs , ys, w, h, 4)

    setColor(99, 155, 255, 255)
    love.graphics.printf('GAME OVER', xs, ys + 4, w, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your Score: ' .. tostring(msg.score), xs , ys +30 , w, 'center')
    love.graphics.printf('Press Space Bar', xs, ys + 46 , w, 'center')
    self.highScores:render(xs,ys + h + 2, gFonts['medium'])
end