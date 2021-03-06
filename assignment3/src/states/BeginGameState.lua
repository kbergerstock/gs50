 --[[
    GD50
    Match-3 Remake

    -- BeginGameState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in right before we start playing;
    should fade in, display a drop-down "Level X" message, then transition
    to the PlayState, where we can finally use player input.
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly baseAppState gRSC
-- luacheck: globals Board fade move_label

BeginGameState = Class{__includes = baseAppState}

function BeginGameState:init()
    self:_init_()
    self.ll_co = coroutine.create(function() end)
    coroutine.resume(self.ll_co)
    self.fade_co = coroutine.create( function() end)
    coroutine.resume(self.fade_co)
    self.nerr = false
    self.done = false
    self.alpha = 1.0

    -- start our level # label off-screen
    self.levelLabelY = -64
end

function BeginGameState:enter(msg)
    -- spawn a board and place it toward the right
    msg.board = Board(self.VW - 272, 16, msg.level,self.rcs)
    --
    -- animate our white screen fade-in, then animate a drop-down with
    -- the level text
    -- once that's finished, start a transition of our text label to
    -- the center of the screen over 0.25 seconds
    --
    self.nerr = false
    self.done = false
    self.alpha = 1.0
    self.fade_co = coroutine.create(fade,-1)
end


function BeginGameState:render(msg)

    -- render board of tiles
    msg.board:render()

    if coroutine.status(self.ll_co) ~= 'dead' then
        -- render Level # label and background rect
        setColor(95, 205, 228, 200)
        love.graphics.rectangle('fill', 0, self.levelLabelY - 8, self.VW, 48)

        setColor(255, 255, 255, 255)
        love.graphics.setFont(gRSC.fonts['large'])
        love.graphics.printf('Level ' .. tostring(msg.level),
            0, self.levelLabelY, self.VW, 'center')

        self.nerr, self.done, self.levelLabelY = coroutine.resume(self.ll_co)

        if self.done then
            msg.Change('play')
        end
    end

    if coroutine.status(self.fade_co) ~= 'dead' then
        self.nerr, self.done, self.alpha = coroutine.resume(self.fade_co, -1)
        if self.done then
            self.ll_co = coroutine.create(move_label)
            self.done = false
        end
    end
    -- our transition foreground rectangle
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.rectangle('fill', 0, 0, self.VW, self.VH)
end