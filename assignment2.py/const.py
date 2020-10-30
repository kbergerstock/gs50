# break out constants 

SCREEN_WIDTH = 1200    
SCREEN_HEIGHT = 800
MSG_WIDTH = SCREEN_WIDTH - 40
SCREEN_TITLE = "BREAK OUT"
SCREEN_COLOR = [ 40,45,52,1 ]
VOLUME = 0.1

# bricK properties
BRICK_TEXTURES = 'resources/breakout.png'
BRICK_WIDTH = 32
BRICK_HEIGHT = 16
BRICK_COL = 6
BRICK_COUNT  = 21
BRICK_SCALE = 2.3
# BALL PROPERTIES
BALL_TEXTURES = 'resources/breakout.png'
BALL_LOCATIOINS = [[96,48,8,8],[104,48,8,8],[112,48,8,8],[120,48,8,8],[96,56,8,8],[104,56,8,8],[112,56,8,8]]
BALL_SCALE = 2.3
BALL_VELOCITY = 5
# PADDLE PROPERTIES 
PADDLE_TEXTURES = 'resources/breakout.png'
PADDLE_LOCATIONS  =  [
                        [0,64,32,16],[32,64,64,16],[96,64,96,16],
                        [0,96,32,16],[32,96,64,16],[96,96,96,16],
                        [0,108,32,16],[32,108,64,16],[96,108,96,16],
                        [0,120,32,16],[32,120,64,16],[96,120,96,16],
                     ]
PADDLE_SCALE = 2.3
PADDLE_VELOCITY = 5

GAME_FONT=("RETRO_FONT","ATARI")

