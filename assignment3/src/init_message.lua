-- initialize nessage packet
-- kebergerstock
-- 2019/01/26

-- luacheck: globals Message
-- luacheck: ignore init_message_packet StartState BeginGameState PlayState GameOverState

require 'lib/message'

function init_message_packet()
    local msg = Message()
    msg.board = {}
    msg.goal = 0
    msg.quit = false
    msg.seconds = 60              -- allowed time to find matches per board
    msg.clear_level_time = 120

    msg.states['start']       =  StartState()
    msg.states['begin-game']  =  BeginGameState()
    msg.states['play']        =  PlayState()
    msg.states['game-over']   =  GameOverState()

    return msg
end
