



pauseState = Class{__includes = BaseState}

function pauseState:enter()
    sounds['music']:setLooping(false)
end

function pauseState:exit()
    sounds['music']:setLooping(true)
    sounds['music']:play()
end

function pauseState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        r = {}
        r['state'] = 'play'
        return r
    end
end

function pauseState:render()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(flappyFont)
    love.graphics.printf('PAUSED', 0, 64, VIRTUAL_WIDTH, 'center')
end