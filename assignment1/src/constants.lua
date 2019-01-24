-- putting all the globals in one location annd require this source file first
-- eliminates circular requirements
-- also will make creating a config file to load them easier
-- keith r. bergerstock

-- luacheck: allow_defined,no unused
-- luacheck: globals love Class
-- luacheck: globals WINDOW_WIDTH WINDOW_HEIGHT VIRTUAL_WIDTH VIRTUAL_HEIGHT
-- luacheck: globals SCROLLING PIPE_SPEED PIPE_WIDTH PIPE_HEIGH
-- luacheck: globals BIRD_WIDTH BIRD_HEIGHT COUNTDOWN_TIME

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75




