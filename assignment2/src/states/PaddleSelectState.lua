
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
-- luacheck: globals gSounds gTextures gFrames gFonts CONST

PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:init()
    self:_init_()
     -- the paddle we're highlighting; will be passed to the ServeState
    -- when we press Enter
    self.currentPaddle = 1
    self.size = 2
    self.width = 64
end

function PaddleSelectState:enter(msgs)
    self.currentPaddle = 1
end

function PaddleSelectState:handleInput(input, msgs)
    if input == 'left' then
        if self.currentPaddle == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle - 1
        end
    elseif input == 'right' then
        if self.currentPaddle == 4 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
    elseif input == '2' then
        self.size , self.width = msgs.paddle:setSize(2)
    elseif input == '3' then
        self.size, self.width = msgs.paddle:setSize(3)
    -- select paddle and move on to the serve state, passing in the selection
    elseif input == 'space' then
        gSounds['confirm']:play()
        -- update the message packet
        msgs.paddle:setSkin(self.currentPaddle)
        msgs.recoverPoints = 5000
        msgs.next = 'serve'
    end
end

function PaddleSelectState:render()
    -- instructions
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select your paddle with left and right!", 0, self.VH / 4,
        self.VW, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("(Press SPACE to continue!)", 0, self.VH / 3,
        self.VW, 'center')

        local r = 40.0 / 255.0
        local b = r
        local g = r
        local a = 0.5

    -- left arrow; should render normally if we're higher than 1, else
    -- in a shadowy form to let us know we're as far left as we can go
    if self.currentPaddle == 1 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(r,g,b,a)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], self.VW / 4 - 24, self.VH - self.VH / 3)

    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1,1,1,1)

    -- right arrow; should render normally if we're less than 4, else
    -- in a shadowy form to let us know we're as far right as we can go
    if self.currentPaddle == 4 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(r,g,b,a)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], self.VW - self.VW / 4, self.VH - self.VH / 3)

    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1,1,1,1)

    -- draw the paddle itself, based on which we have selected
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.currentPaddle - 1)],
        (self.VW - self.width )/2 , self.VH - self.VH / 3)
end