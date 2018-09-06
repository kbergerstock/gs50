--[[
    GD50
    Breakout Remake

    -- ServeState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The state in which we are waiting to serve the ball; here, we are
    basically just moving the paddle left and right with the ball until we
    press Enter, though everything in the actual game now should render in
    preparation for the serve, including our current health and score, as
    well as the level we're on.
]]

ServeState = Class{__includes = BaseState}


function ServeState:init()

end

function ServeState:enter(msgs)    
    self:MakeLevel(msgs)
    msgs.paddle:reset()
    msgs.balls:reset()
    msg.powerUps:reset()
end

function ServeState:MakeLevel(msgs)
    if msgs.makeLevel  then        
        msgs.bricks, msgs.keyBrickFlag  = LevelMaker.createMap(msgs.level)
        msgs.keyCaught = false
        msgs.breakout = false
        msgs.makeLevel = (msgs.bricks == nil )
    end
end

function ServeState:update(keysPressed, msgs, dt)
    -- have the ball track the player
    msgs.paddle:update(dt)
    msgs.balls:track(msgs.paddle)

    if keysPressed:getSpace() then
        if msgs.makeLevel then
            self:MakeLevel(msgs)
        else
            -- pass in all important state info to the PlayState
            msgs.next = 'play'
        end
     end
end

function ServeState:render(msgs)
    msgs.paddle:render()
    msgs.balls:render()
    msgs.powerUps:render()

    if msgs.makeLevel then 
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('Level creation error press space again ', 0, VIRTUAL_HEIGHT / 3,
            VIRTUAL_WIDTH, 'center')
    else
        for k, brick in pairs(msgs.bricks) do
            brick:render()
        end
    end

    renderScore(msgs.score)
    renderHealth(msgs.health)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(msgs.level), 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Space to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end