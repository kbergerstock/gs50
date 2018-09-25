--[[
    GD50
    Match-3 Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    State in which we can actually play, moving around a grid cursor that
    can swap two tiles; when two tiles make a legal swap (a swap that results
    in a valid match), perform the swap and destroy all matched tiles, adding
    their values to the player's point score. The player can continue playing
    until they exceed the number of points needed to get to the next level
    or until the time runs out, at which point they are brought back to the
    main menu or the score entry menu if they made the top 10.
]]

-- luacheck: allow_defined, no unused, globals Class setColor love BaseState

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.kd_co = coroutine.create(function() end)
    coroutine.resume(self.kd_co)
    self.fade_co = coroutine.create( function() end)
    coroutine.resume(self.fade_co)
    self.nerr = false
    self.done = false
    self.tick = false
    self.alpha = 1.0
    self.seconds = 0
    self.m = 'not started'

    -- position in the grid which we're highlighting
    self.boardHighlightX = 0
    self.boardHighlightY = 0

    self.tileX = 0
    self.TileY = 0

    self.mouse_co = coroutine.create( handle_mouse_input,1)
    self.update_co = coroutine.create(function() end)
end

function PlayState:enter(msg)
    assert(msg.board,'no board in message packet')

    self.kd_co = coroutine.create(countdown,1)
    coroutine.resume(self.kd_co,msg.seconds)

    self.update_co = coroutine.create(updateBoard,msg,1)

    -- score we have to reach to get to the next level
    msg.goal =  msg.level * 1.25 * 1000

    msg.board:setBomb(2,2)
end

function PlayState:exit(msg)
    self.nerr = coroutine.resume(self.update_co, msg, 99)
    if msg.seconds > 20 and msg.score > msg.goal then
         msg.seconds = msg.seconds - 5
    end
end



function PlayState:update(inputs, msg, dt)

    if coroutine.status(self.update_co) ~= 'dead' then
        self.nerr  = coroutine.resume(self.update_co,msg,1)
        assert(self.nerr,'there is an error in update board')
    else
        self.m = 'redflag'
    end

    -- go back to start if time runs out
    if self.seconds == 0 then
        gSounds['game-over']:play()
        msg.nextState('game-over')
    end

    -- go to next level if we surpass score goal
    if msg.score >= msg.goal then
        gSounds['next-level']:play()
        msg.level = msg.level + 1
        msg.nextState('begin-game')
    end
end

function PlayState:render(msg)

    local cx = 0
    local cy = 0
    local sx = 0
    local sy = 0
    local b1 = false
    local b2 = false
    -- tile we're currently highlighting (preparing to swap)
    if coroutine.status(self.mouse_co) ~= 'dead' then
        self.nerr, cx, cy, sx, sy, b1, b2  = coroutine.resume(self.mouse_co,1)
        assert(self.nerr,"there is an error in handle mouse")
        if b1 and not msg.board.match_found then
            self.m = ''
            msg.board:toggleTile(cx,cy)
        end
    end
    -- execute the countdown timer
    if coroutine.status(self.kd_co) ~= 'dead' then
        self.nerr,self.done,self.tick,self.seconds = coroutine.resume( self.kd_co,1)
        assert(self.nerr,"there is an error in countdown !!")
    end
    -- render board of tiles
    msg.board:render(self.tick)

    -- render highlight rect color based on tick state
    if self.tick then
        setColor(217, 87, 99, 255)
    else
        setColor(172, 50, 50, 255)
    end

    -- draw actual cursor rect
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', cx * 32 + 240, (7- cy) * 32 + 16, 32, 32, 4)

    -- GUI text
    setColor(56, 56, 56, 234)
    love.graphics.rectangle('fill', 16, 16, 186, 186, 6, 4) -- org 116

    setColor(99, 155, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(msg.level), 20, 24, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(msg.score), 20, 52, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(msg.goal), 20, 80, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.seconds), 20, 108, 182, 'center')
end