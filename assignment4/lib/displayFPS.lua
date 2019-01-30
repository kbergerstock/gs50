-- Renders the current FPS.
-- luacheck: globals love, ignore displayFPS

function displayFPS(font)
    -- simple FPS display across all states
    love.graphics.setFont(font)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end