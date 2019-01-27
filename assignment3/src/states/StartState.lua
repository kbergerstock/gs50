--[[
    GD50
    Match-3 Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Match-3" in large text, as well as a message to press
    Enter to begin.
]]

-- luacheck: allow_defined, no unused, globals Class setColor love baseAppState
-- luacheck: globals gRSC fade updateColorBank

StartState = Class{__includes = baseAppState}

function StartState:init()
    self:_init_()
    -- currently selected menu item
    self.currentMenuItem = 1

    self.psoitions = {}
    self.done = false
    self.error = false
    self.next = 'idle'
    self.alpha = 0.0

    -- colors we'll use to change the title text
    self.colors = {
        [1] = {217, 87, 99, 255},
        [2] = {95, 205, 228, 255},
        [3] = {251, 242, 54, 255},
        [4] = {118, 66, 138, 255},
        [5] = {153, 229, 80, 255},
        [6] = {223, 113, 38, 255},
    }
    -- duplicate the color table so all we have to do is shift an index to change colors
        for i = 1, 6 do
            self.colors[i + 6] = self.colors[i]
        end

    -- letters of MATCH 3 and their spacing relative to the center
    self.letterTable = {
        {'M', -108},
        {'A', -64},
        {'T', -28},
        {'C', 2},
        {'H', 40},
        {'3', 112}
    }

    -- create a thead to the color bank routine
    self.colorBank_co = coroutine.create(updateColorBank)
    -- cretate a thread for the fade routine and ensure it is dead
    self.fade_co = coroutine.create(function() end)
    coroutine.resume(self.fade_co)
end

function StartState:generateTable()
    local positions = {}
    -- generate full table of tiles just for display
    for i = 1, 64 do
        table.insert(positions, gRSC.frames['tiles'][math.random(18)][math.random(6)])
    end
    return positions
end

function StartState:enter(msg)
    self.done = false
    self.error = false
    self.alpha = 0.0
    msg.level = 1
    msg.score = 0
    self.next = 'idle'
    msg.seconds = 60
    self.fade_co = coroutine.create(function() end)
    coroutine.resume(self.fade_co)
    self.positions = self:generateTable()
end

function StartState:handleInput(input, msg)

    local status = coroutine.status(self.fade_co)
    if status == 'dead' then
        -- process the inputs
        -- change menu selection
        if input == 'up' or input == 'down' then
            self.currentMenuItem = self.currentMenuItem == 1 and 2 or 1
            gRSC.sounds['select']:play()
        end

        -- switch to another state via one of the menu options
        if input == 'space' then
            if self.currentMenuItem == 1 then
                -- transition to the BeginGame state after the animation is over
                self.fade_co = coroutine.create(fade,1)
                self.next = 'begin-game'
            else
                msg.Change('idle')
                msg.quit = true
            end
        end
    end
end

function StartState:render(msg)
    -- render all tiles and their drop shadows
    for y = 1, 8 do
        for x = 1, 8 do

            -- render shadow first
            setColor(0, 0, 0, 255)
            love.graphics.draw(gRSC.textures['main'], self.positions[(y - 1) * x + x],
                (x - 1) * 32 + 128 + 3, (y - 1) * 32 + 16 + 3)

            -- render tile
            setColor(255, 255, 255, 255)
            love.graphics.draw(gRSC.textures['main'], self.positions[(y - 1) * x + x],
                (x - 1) * 32 + 128, (y - 1) * 32 + 16)
        end
    end

    -- keep the background and tiles a little darker than normal
    setColor(0, 0, 0, 128)
    love.graphics.rectangle('fill', 0, 0, self.VW, self.VW)

    self:drawMatch3Text(-60)
    self:drawOptions(12)

    -- draw our transition rect; is normally fully transparent, unless we're moving to a new state
    local status = coroutine.status(self.fade_co)
    if status ~= 'dead' then
        self.error, self.done, self.alpha = coroutine.resume(self.fade_co,1)
            -- if the fade is complete advance state
        if self.done then
            msg.Change(self.next)
        end
    end
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.rectangle('fill', 0, 0, self.VW, self.VW)
end

--[[
    Draw the centered MATCH-3 text with background rect, placed along the Y
    axis as needed, relative to the center.
]]
function StartState:drawMatch3Text(y)
    local nerr = false
    local colorBank = 0
    nerr, colorBank = coroutine.resume(self.colorBank_co, 1)

    -- draw semi-transparent rect behind MATCH 3
    setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', self.VW / 2 - 76, self.VH / 2 + y - 11, 150, 58, 6)

    -- draw MATCH 3 text shadows
    love.graphics.setFont(gRSC.fonts['large'])
    self:drawTextShadow('MATCH 3', self.VH / 2 + y)

    -- print MATCH 3 letters in their corresponding current colors
    for i = 1, 6 do
        setColor(self.colors[colorBank + i])
        love.graphics.printf(self.letterTable[i][1], 0, self.VH / 2 + y, self.VW + self.letterTable[i][2], 'center')
    end
end

--[[
    Draws "Start" and "Quit Game" text over semi-transparent rectangles.
]]
function StartState:drawOptions(y)

    -- draw rect behind start and quit game text
    setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', self.VW / 2 - 76, self.VH / 2 + y, 150, 58, 6)

    -- draw Start text
    love.graphics.setFont(gRSC.fonts['medium'])
    self:drawTextShadow('Start', self.VH / 2 + y + 8)

    if self.currentMenuItem == 1 then
        setColor(99, 155, 255, 255)
    else
        setColor(48, 96, 130, 255)
    end

    love.graphics.printf('Start', 0, self.VH / 2 + y + 8, self.VW, 'center')

    -- draw Quit Game text
    love.graphics.setFont(gRSC.fonts['medium'])
    self:drawTextShadow('Quit Game', self.VH / 2 + y + 33)

    if self.currentMenuItem == 2 then
        setColor(99, 155, 255, 255)
    else
        setColor(48, 96, 130, 255)
    end

    love.graphics.printf('Quit Game', 0, self.VH / 2 + y + 33, self.VW, 'center')
end

--[[
    Helper function for drawing just text backgrounds; draws several layers of the same text, in
    black, over top of one another for a thicker shadow.
]]
function StartState:drawTextShadow(text, y)
    setColor(34, 32, 52, 255)
    love.graphics.printf(text, 2, y + 1, self.VW, 'center')
    love.graphics.printf(text, 1, y + 1, self.VW, 'center')
    love.graphics.printf(text, 0, y + 1, self.VW, 'center')
    love.graphics.printf(text, 1, y + 2, self.VW, 'center')
end