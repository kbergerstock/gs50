--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Breakout" in large text, as well as a message to press
    Enter to begin.
]]
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts gConst

-- the "__includes" bit here means we're going to inherit all of the methods
-- that BaseState has, so it will have empty versions of all StateMachine methods
-- even if we don't override them ourselves; handy to avoid superfluous code!
StartState = Class{__includes = BaseState}



-- initialize the return msg
function StartState:init()
    self:_init_()
     -- whether we're highlighting "Start" or "High Scores"
    self.highlighted = 1
    self.hilite = 103.0 / 255.0 -- hilite color
    self.V70 = self.VH / 2 + 60
    self.V90 = self.VH / 2 + 80
end

function StartState:enter(msgs)
    if msgs.balls == nil then
        msgs.balls = Balls()
    end
    if msgs.paddle == nil then
        msgs.paddle = Paddle()
    end
    --initialize the high scores
     msgs.hsObj:loadHighScores('breakout')
     msgs.level = 1
     msgs.score = 0
     msgs.health = 3
     msgs.makeLevel = true
     msgs.keyBrickFlag = false
     msgs.keyCaught = false
    self.highlighted = 1
end

function StartState:handleInput(input, msgs)
    -- toggle highlighted option if we press an arrow key up or down
    if input == ('up') or input == ('down') then
        self.highlighted = (self.highlighted == 1) and 2 or 1
        gSounds['paddle-hit']:play()
    -- confirm whichever option we have selected to change screens
    elseif input == 'space' then
        gSounds['confirm']:play()
        if self.highlighted == 1 then
            msgs.next = 'paddle_select'
        else
            msgs.next = 'high_scores'
        end
    end
end

function StartState:render(msgs)
    -- title
    love.graphics.setColor(0,0.75,0,1 )
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("BREAKOUT", 0, self.VH / 3, self.VW, 'center')
    love.graphics.setColor(1,1,1,1 )

    -- instructions
    love.graphics.setFont(gFonts['medium'])

    -- if we're highlighting 1, render that option blue
    if self.highlighted == 1 then
        love.graphics.setColor(self.hilite,1,1,1)
    end
    love.graphics.printf("START", 0, self.V70, self.VW, 'center')

    love.graphics.setColor(1,1,1,1 )

    -- render option 2 blue if we're highlighting that one
    if self.highlighted == 2 then
        love.graphics.setColor(self.hilite,1,1,1)
    end
    love.graphics.printf("HIGH SCORES", 0, self.V90 , self.VW, 'center')

    love.graphics.setColor(1,1,1,1 )
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press Space to return to make selection!",0, self.VH - 18, self.VW, 'center')
end