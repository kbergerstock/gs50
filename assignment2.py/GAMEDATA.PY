# breakout game data class
# K. r. bergerstock
# 10/21/2020

import const
import arcade
from arcade import color
from game_controller import game_device
from game_controller import game_controller
from ball import BALL
from paddle import PADDLE
from background import Background

import random
import time

class gameData():
    def __init__(self):
        self.score =  0
        self.health = 0
        self.level = 0 
        self.high_scores = None             # high scores list
        self.backgnd = None                 # moving background sprite list    
        self.window = None                  # window handle
        self.snds = {}                      # game sounds list
        self.gc = None                      # game controller
        # sprite lists
        self.bricks = None
        self.ball = None
        self.paddle = None
        self.sprites = None
        # texture lists
        self.textures = {}
        self.textures['bricks'] = None 
        self.textures['balls'] = None
        self.textures['paddles'] = None
        self.textures['arrows'] = None
        # views (ie lua states)
        self.start_view = None              # view references    
        self.select_view = None
        self.serve_view = None
        #initialize main screen
        self.__start__()                    

    def __start__(self):    
        random.seed()
        # load the sounds
        self.snds['music']  = arcade.Sound('resources/music.wav',True)
        self.snds['victory'] = arcade.Sound('resources/victory.wav')
        self.snds['select'] = arcade.Sound('resources/select.wav')
        self.snds['no-select'] = arcade.Sound('resources/no-select.wav')
        self.snds['confirm'] = arcade.Sound('resources/confirm.wav')
        self.snds['wall-hit'] = arcade.Sound('resources/wall_hit.wav')
        self.snds['paddle-hit'] = arcade.Sound('resources/paddle_hit.wav')
        self.snds['pause'] = arcade.Sound('resources/pause.wav')
        self.snds['score'] = arcade.Sound('resources/score.wav')
        self.snds['brick-hit-1'] = arcade.Sound('resources/brick-hit-1.wav')
        self.snds['brick-hit-2'] = arcade.Sound('resources/brick-hit-2.wav')
        self.snds['high_score'] = arcade.Sound('resources/high_score.wav')
        self.snds['recover'] = arcade.Sound('resources/recover.wav')
        self.window = arcade.Window(const.SCREEN_WIDTH,const.SCREEN_HEIGHT-10, const.SCREEN_TITLE)
        arcade.set_viewport(0,const.SCREEN_WIDTH,5,const.SCREEN_HEIGHT-5)
        self.snds['music'].play(const.VOLUME)

        # load the textures
        self.textures['bricks'] = arcade.load_spritesheet(const.BRICK_TEXTURES,const.BRICK_WIDTH, 
               const.BRICK_HEIGHT,const.BRICK_COL,const.BRICK_COUNT )
        self.textures['balls'] = arcade.load_textures(const.BALL_TEXTURES,const.BALL_LOCATIOINS)
        self.textures['paddles'] = arcade.load_textures(const.PADDLE_TEXTURES,const.PADDLE_LOCATIONS)
        self.textures['arrows'] = arcade.load_textures(const.ARROW_TEXTURES,const.ARROW_LOCATIONS)
        # create the game controller interface
        self.gc = game_controller(game_device.setup())
        self.sprites = arcade.SpriteList()
    
    def show_view(self,view):
        """ activate the draw,update methods for the current view """
        self.window.show_view(view)

    def setup(self):
        self.score = 0
        self.health = 3

    def render_score(self,x,y,color,size,Font):
        arcade.draw_text('{0:08}'.format(self.score),x,y,color,font_size=size,font_name=Font)

    def render_health(self,x,y):
        pass
