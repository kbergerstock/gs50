-- luacheck: globals Message HighScoreTracker PowerUps

function init_msg_packet()
    local msg = Message()
    msg.bricks  = {}
    msg.balls   = nil
    msg.paddle  = nil
    msg.makeLevel = false
    msg.keyBrickFlag = false
    msg.keyCaught = false
    msg.breakout = false
    msg.hsObj     = HighScoreTracker(10)
    msg.powerUps  = PowerUps()

    return msg
end