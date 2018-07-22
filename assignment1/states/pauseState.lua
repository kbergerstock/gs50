



pauseState = Class{__includes = BaseState}

function pauseState:enter()
    sounds['music']:stop()
    sounds['music']:setLooping(false)
    sounds['pause']:setLooping(true)
    sounds['pause']:play()
    
end

function pauseState:exit()
    sounds['pause']:stop()
    sounds['pause']:setLooping(false)
    sounds['music']:setLooping(true)
    sounds['music']:play()
end

function pauseState:update(dt)
    if love.keyboard.wasPressed('p') or love.keyboard.wasPressed('P') then
        return {state = 'play'}
    end
end

function pauseState:render()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(flappyFont)
    love.graphics.printf('GAME PAUSED', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)    
    love.graphics.setFont(mediumFont)
    love.graphics.printf('PRESS P TO EXIT',0,100,VIRTUAL_WIDTH, 'center')
end