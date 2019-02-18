-- gamePad.lua
-- k r bergerstock

-- handles gamepads
-- luacheck: allow_defined, no unused
-- luacheck: globals  love

function GamePad()
    -- create the virtual register
    self =  {
                io_states = {},
                rx = 0,
                ry = 0,
                lx = 0,
                ly = 0,
            }
            self.io_states['a'] = false
            self.io_states['b'] = false
            self.io_states['x'] = false
            self.io_states['y'] = false
            self.io_states['j1up'] = false
            self.io_states['j1dn'] = false
            self.io_states['j1lt'] = false
            self.io_states['j1rt'] = false
            self.io_states['f1up'] = false
            self.io_states['f1dn'] = false
            self.io_states['f1lt'] = false
            self.io_states['f1rt'] = false

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
            self.io_states[button] = true
        end
    end

    function love.gamepadreleased(joystick ,  button )
        if game_pad == joystick then
            self.io_states[button] = false
        end
    end

    function self.readJoysticks()
        if game_pad then
            -- read raw data and store it
            self.rx = game_pad:getGamepadAxis('rightx')
            self.ry = game_pad:getGamepadAxis('righty')
            self.lx = game_pad:getGamepadAxis('leftx')
            self.ly = game_pad:getGamepadAxis('lefty')
            -- determine on/off state for joystick 1
            local right = (self.rx > 0.6)
            local left  = (self.rx < -0.6)
            local down  = (self.ry > 0.6)
            local up    =  (self.ry < -0.6)
            -- oneshot:determine if this reading is first high detected after a low
            self.io_states['f1rt'] = right and not(right == self.io_states['j1rt'])
            self.io_states['f1lt'] = left  and not(left  == self.io_states['j1lt'])
            self.io_states['f1dn'] = down  and not(down  == self.io_states['j1dn'])
            self.io_states['f1up'] = up    and not(up    == self.io_states['j1up'])
            -- store digital state for joy 1
            self.io_states['j1rt'] = right
            self.io_states['j1lt'] = left
            self.io_states['j1dn'] = down
            self.io_states['j1up'] = up
        end
        return self.io_states
    end
    return self
end

-- truth table for  one shot
-- this pass    last pass   ==     not   this pass  AND
--    T             T       T       F       T       F
--    T             F       F       T       T       T
--    F             T       F       T       F       F
--    F             F       T       F       F       F