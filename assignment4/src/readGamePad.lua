-- luacheck: globals love
-- luacheck: ignore readGamePad

function readGamePad(gamePad)
    local button = ''
    gamePad:readJoysticks()
    if  gamePad.io_states['f1lt'] then
        button = 'left'
        gamePad.io_states['f1lt'] = false
    elseif  gamePad.io_states['f1rt'] then
        button = 'right'
        gamePad.io_states['f1rt'] = false
    elseif  gamePad.io_states['f1up'] then
        button = 'up'
        gamePad.io_states['f1up'] = false
    elseif  gamePad.io_states['f1dn'] then
        button = 'down'
        gamePad.io_states['f1dn'] = false
    elseif gamePad.io_states['b'] then    -- is true on detected false otherwise
        button = 'GPb'                 -- assign to return value
        gamePad.io_states['b'] = false    -- debounce the button
    elseif gamePad.io_states['a'] then
        button = 'GPa'
        gamePad.io_states['a'] = false
    elseif gamePad.io_states['x'] then
        button = 'GPx'
        gamePad.io_states['x'] = false
    elseif gamePad.io_states['y'] then
        button = 'GPy'
        gamePad.io_states['y'] = false
    end
    local hInput = 0
    if  gamePad.io_states['j2lt'] or love.keyboard.isDown('left') then
        hInput = -1
    elseif  gamePad.io_states['j2rt'] or love.keyboard.isDown('right')  then
        hInput = 1
    end
    local vInput = 0
    if  gamePad.io_states['j2up'] or love.keyboard.isDown('up') then
        vInput = 1
    elseif  gamePad.io_states['j2dn'] or love.keyboard.isDown('down')  then
        vInput = -1
    end
    return button, hInput, vInput
end