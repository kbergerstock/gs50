-- gamePad.lua
-- k r bergerstock

-- handles gamepads
-- luacheck: allow_defined, no unused
-- luacheck: ignore GamePad globals love

function GamePad()
    -- create the virtual register
    local self =  {
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

            self.io_states['j2up'] = false
            self.io_states['j2dn'] = false
            self.io_states['j2lt'] = false
            self.io_states['j2rt'] = false
            self.io_states['f2up'] = false
            self.io_states['f2dn'] = false
            self.io_states['f2lt'] = false
            self.io_states['f2rt'] = false

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
            -- determine on/off state for joysticks1
            local right_1 = (self.rx > 0.6)
            local left_1  = (self.rx < -0.6)
            local down_1  = (self.ry > 0.6)
            local up_1    = (self.ry < -0.6)
            -- oneshot:determine if this reading is first high detected after a low
            self.io_states['f1rt'] = right_1 and not(right_1 == self.io_states['j1rt'])
            self.io_states['f1lt'] = left_1  and not(left_1  == self.io_states['j1lt'])
            self.io_states['f1dn'] = down_1  and not(down_1  == self.io_states['j1dn'])
            self.io_states['f1up'] = up_1    and not(up_1    == self.io_states['j1up'])
            -- store digital state for joy 1
            self.io_states['j1rt'] = right_1
            self.io_states['j1lt'] = left_1
            self.io_states['j1dn'] = down_1
            self.io_states['j1up'] = up_1
            -- determine on/off state for joysticks2
            local right_2 = (self.lx > 0.6)
            local left_2  = (self.lx < -0.6)
            local down_2  = (self.ly > 0.6)
            local up_2    = (self.ly < -0.6)
            -- oneshot:determine if this reading is first high detected after a low
            self.io_states['f2rt'] = right_2 and not(right_2 == self.io_states['j2rt'])
            self.io_states['f2lt'] = left_2  and not(left_2  == self.io_states['j2lt'])
            self.io_states['f2dn'] = down_2  and not(down_2  == self.io_states['j2dn'])
            self.io_states['f2up'] = up_2    and not(up_2    == self.io_states['j2up'])
            -- store digital state for joy 1
            self.io_states['j2rt'] = right_2
            self.io_states['j2lt'] = left_2
            self.io_states['j2dn'] = down_2
            self.io_states['j2up'] = up_2
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