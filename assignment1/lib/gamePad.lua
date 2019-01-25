-- gamePad.lua
-- k r bergerstock

-- handles gamepads
-- luacheck: allow_defined, no unused
-- luacheck: globals  love

function GamePad()
    -- create the virtual register
    self =  {
                inputs = {},
                rx = 0,
                ry = 0,
                lx = 0,
                ly = 0,
            }
            self.inputs['a'] = false
            self.inputs['b'] = false
            self.inputs['x'] = false
            self.inputs['y'] = false
            self.inputs['j1up'] = false
            self.inputs['j1dn'] = false
            self.inputs['j1lt'] = false
            self.inputs['j1rt'] = false

    local game_pad = nil

    function love.joystickadded(joystick)
        if joystick:isGamepad() then
            game_pad = joystick
        end
    end

    function love.joystickremoved(joystick)
        if game_pad == joystick then
            game_pad = nil
        end
    end

    function love.gamepadpressed(joystick , button )
        if game_pad == joystick then
            self.inputs[button] = true
        end
    end

    function love.gamepadreleased(joystick ,  button )
        if game_pad == joystick then
            self.inputs[button] = false
        end
    end

    function self.readAxis()
        if game_pad then
            self.rx = game_pad:getGamepadAxis('rightx')
            self.ry = game_pad:getGamepadAxis('righty')
            self.lx = game_pad:getGamepadAxis('leftx')
            self.ly = game_pad:getGamepadAxis('lefty')
            self.inputs['j1rt'] = (self.rx > 0.6)
            self.inputs['j1lt'] = (self.rx < -0.6)
            self.inputs['j1dn'] = (self.ry > 0.6)
            self.inputs['j1up'] = (self.ry < -0.6)
        end
    end

    return self
end


