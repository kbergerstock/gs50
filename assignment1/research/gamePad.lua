-- gamePad.lua
-- k r bergerstock

-- handles gamepads
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love

GamePad = Class{}


function GamePad:init()
    self.game_pad = nil
end
function GamePad:add(joystick)
    self.game_pad = joystick
end

function GamePad:remove(joystick)
    if self.game_pad == joystick then
        self.game_pad = nil
    end
end

function GamePad:buttonDown(joystick,button)
    if self.game_pad == joystick then
        return 'GP'..button
    else
        return 'NA'
    end
end

function GamePad:readAxis()
    local rv = nil
    if self.game_pad then
        local gp = self.game_pad
        local rx = gp:getGamepadAxis('rightx')
        local ry = gp:getGamepadAxis('righty')
        local lx = gp:getGamepadAxis('leftx')
        local ly = gp:getGamepadAxis('lefty')

        rv = {
               rightX = rx,
               rightY = ry,
               leftX = lx,
               leftY = ly,
               joyRight = (rx > 0.6),
               joyLeft  = (rx < -0.6),
               joyUp    = (ry > 0.6),
               joyDown  = (ry < -0.6)
        }
    end
    return rv
end