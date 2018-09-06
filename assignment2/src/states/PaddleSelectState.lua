
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

PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:init()
     -- the paddle we're highlighting; will be passed to the ServeState
    -- when we press Enter
    self.currentPaddle = 1
    self.size = 2
    self.width = 64
end

function PaddleSelectState:enter(msgs)
    self.currentPaddle = 1
end

function PaddleSelectState:update(keysPressed, msgs, dt)
    if keysPressed:get('left') then
        if self.currentPaddle == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle - 1
        end
    elseif keysPressed:get('right') then
        if self.currentPaddle == 4 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
    end
    if keysPressed:get('2') then
        self.size , self.width = msgs.paddle:setSize(2)
    end
    if keysPressed:get('3') then
        self.size, self.width = msgs.paddle:setSize(3)
    end
    -- select paddle and move on to the serve state, passing in the selection
    if keysPressed:getSpace() then
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
    love.graphics.printf("Select your paddle with left and right!", 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("(Press SPACE to continue!)", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
        
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
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
   
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1,1,1,1)

    -- right arrow; should render normally if we're less than 4, else
    -- in a shadowy form to let us know we're as far right as we can go
    if self.currentPaddle == 4 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(r,g,b,a)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    
    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(1,1,1,1)

    -- draw the paddle itself, based on which we have selected
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.currentPaddle - 1)],
        (VIRTUAL_WIDTH - self.width )/2 , VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
end