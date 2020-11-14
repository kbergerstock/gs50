# break out constants 
# 11/14/2020 CONVERTED LISTS TO TUPLES

SCREEN_WIDTH = 1120   
SCREEN_HEIGHT = 800
MSG_WIDTH = SCREEN_WIDTH - 40
SCREEN_TITLE = "BREAK OUT"
SCREEN_COLOR = ( 40,45,52,1 )
VOLUME = 0.1

# bricK properties
BRICK_TEXTURES = 'resources/breakout.png'
BRICK_WIDTH = 32
BRICK_HEIGHT = 16
BRICK_COL = 6
BRICK_COUNT  = 21
BRICK_SCALE = 2.5
# BALL PROPERTIES
BALL_TEXTURES = 'resources/breakout.png'
BALL_LOCATIOINS = ((96,48,8,8),(104,48,8,8),(112,48,8,8),(120,48,8,8),(96,56,8,8),(104,56,8,8),(112,56,8,8))
BALL_SCALE = 2.5
BALL_VELOCITY = 5
# PADDLE PROPERTIES 
PADDLE_TEXTURES = 'resources/breakout.png'
PADDLE_LOCATIONS  =  (
                        (0,64,32,16),(32,64,64,16),(96,64,96,16),(0,80,128,16),
                        (0,96,32,16),(32,96,64,16),(96,96,96,16),(0,112,128,16),
                        (0,128,32,16),(32,128,64,16),(96,128,96,16),(0,144,128,16),
                        (0,160,32,16),(32,160,64,16),(96,160,96,16),(0,176,128,16),
                     )
PADDLE_SCALE = 2.5
PADDLE_VELOCITY = 5
# arrow properties
ARROW_TEXTURES = 'resources/arrows.png'
ARROW_LOCATIONS =((0,0,24,24),(24,0,24,24) )
ARROW_SCALE = 2

GAME_FONT=("RETRO_FONT","ATARI")

