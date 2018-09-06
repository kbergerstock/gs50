function init_msg_packet()
    msg = {}
    msg.next    = 'idle'
    msg.bricks  = {}
    msg.balls   = nil
    msg.paddle  = nil
    msg.score   = 0
    msg.health  = 3
    msg.level   = 0
    msg.makeLevel = false 
    msg.keyBrickFlag = false 
    msg.keyCaught = false 
    msg.breakout = false
    msg.hsObj     = HighScoreTracker(10)
    msg.powerUps  = PowerUps()
    
    return msg
end