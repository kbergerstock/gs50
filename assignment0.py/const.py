# pong constants 

SCREEN_WIDTH = 1280     
SCREEN_HEIGHT =800
MSG_WIDTH = SCREEN_WIDTH - 40
SCREEN_TITLE = "PONG"
SCREEN_COLOR = [ 40,45,52,1 ]
VIRTUAL_WIDTH = 320
VIRTUAL_HEIGHT = 200

# paddle movement speed
PADDLE_SPEED = 120
BALL_SPEED_H = 150
BALL_SPEED_L = 50

def translateX(x):
    return x * SCREEN_WIDTH / VIRTUAL_WIDTH

def translateY(y):
    return y * SCREEN_HEIGHT / VIRTUAL_HEIGHT

def point( vx ,vy):
    return translateX(vx),translateY(vy)

def width(l):
    return translateX(l)

def height(l):
    return translateY(l)    

GAME_FONT=("RETRO_FONT","ATARI","Terminal")