-- joystick.lua
-- k r bergerstock

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor GAME_PADS

GamePad = Class{}

function GamePad:init()
    self.gamePads = GAME_PADS
    self.count = #self.gamePads
    self.active = self.gamePads[1]:isGamepad() and true or false
end

function GamePad:input()
    if self.active then
        local gp = self.gamePads[1]
        local rv = {
                rightx = gp:getGamepadAxis('rightx'),
                righty = gp:getGamepadAxis('righty'),
                leftx  = gp:getGamepadAxis('leftx'),
                lefty  = gp:getGamepadAxis('lefty'),
                buttonA = gp:isGamepadDown('a'),
                buttonB = gp:isGamepadDown('b'),
                buttonX = gp:isGamepadDown('x'),
                buttonY = gp:isGamepadDown('y'),
        }
        return rv
    end
    return false
end