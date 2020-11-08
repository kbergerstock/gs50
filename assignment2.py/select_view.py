"""
python BREAK_OUT 
select_view.py
krbergerstck june ,2020
"""

import const
import arcade
from arcade import color
import random

from GAMEDATA import gameData
from background import Background
from paddle import PADDLE 
from ball import BALL
import levels
class selectView(arcade.View):
    def __init__(self):
        super().__init__()
        self.gd = None                      # reference to the game data
        self.sprites = arcade.SpriteList()
        self.bricks = None
        self.ball = BALL()
        self.sprites.append(self.ball)
        self.paddle = PADDLE()
        self.sprites.append(self.paddle)
        
        self.key_code = 0

    def setup(self,game_data):
        self.gd = game_data
        self.bricks = levels.level_1(self.gd)
        for i in range(7):
            self.ball.append_texture(self.gd.textures['balls'][i])
        self.ball.set_position(900,30)
        self.ball.set_texture(2)
        for i in range(4):
            self.paddle.append_texture(self.gd.textures['paddles'][i])
        self.paddle.set_position(600,30)
        self.paddle.set_texture(1)

    def on_show(self):
        arcade.set_background_color(const.SCREEN_COLOR)

    def on_draw(self):
        # This command should happen before we start drawing. It will clear
        # the screen to the background color, and erase what we drew last frame.            
        arcade.start_render()
        self.gd.backgnd.draw()
        self.bricks.draw()
        self.sprites.draw()
        #arcade.draw_text('buttonB {0}'.format(self.gd.gc.buttonB()),50,20,color.ALICE_BLUE,font_size=8,font_name=const.GAME_FONT[1])
        #arcade.draw_text('key_code {0:3}'.format(self.key_code),50,100,color.ALICE_BLUE,font_size = 24,font_name=const.GAME_FONT[1])
        arcade.draw_text('to serve press button  "B"',250,150,color.ALICE_BLUE,font_size=32,width=700,align='center',font_name=const.GAME_FONT[0])
        arcade.set_viewport(0,const.SCREEN_WIDTH,5,const.SCREEN_HEIGHT - 5)      
    
    def update(self,delta_time):
        self.gd.backgnd.update()
        self.paddle.update(self.gd.gc.axisX())
        self.ball.update(self.paddle,self.bricks)

    def on_key_press(self, symbol: int, modifiers: int):
        self.key_code = symbol


