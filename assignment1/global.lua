-- putting all the globals in one location annd require this source file first
-- eliminates circular requirements 
-- also will make creating a config file to load them easier
-- keith r. bergerstock

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- controls the background scrolling
SCROLLING = true

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288
GAP_LEVEL = 15

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

-- this function is ot part f the class 
-- it needs to usable to check y boundries
function checkBoundries(y)
    return math.max(-PIPE_HEIGHT + 10, math.min( y , VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT) )
end  