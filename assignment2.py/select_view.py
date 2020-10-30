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
class selectView(arcade.View):
    def __init__(self):
        super().__init__()
        self.gd = None                      # reference to the game data
        self.sprites = arcade.SpriteList()
        self.sprite = arcade.Sprite()
        self.sprites.append(self.sprite)
        self.ball = BALL()
        self.sprites.append(self.ball)
        self.paddle = PADDLE()
        self.sprites.append(self.paddle)
        
        self.key_code = 0

    def setup(self,game_data):
        self.gd = game_data
        self.sprite.append_texture(self.gd.bricks[3])
        self.sprite.set_position(100,500)
        self.sprite.set_texture(0)
        self.sprite.scale = const.BRICK_SCALE
        self.ball.append_texture(self.gd.balls[3])
        self.ball.set_position(600,400)
        self.ball.set_texture(0)
        self.paddle.append_texture(self.gd.paddles[0])
        self.paddle.append_texture(self.gd.paddles[1])
        self.paddle.append_texture(self.gd.paddles[2])
        self.paddle.set_position(600,30)
        self.paddle.set_texture(1)

    def on_show(self):
        arcade.set_background_color(const.SCREEN_COLOR)

    def on_draw(self):
        # This command should happen before we start drawing. It will clear
        # the screen to the background color, and erase what we drew last frame.            
        arcade.start_render()
        self.gd.backgnd.draw()
        self.sprites.draw()
        #arcade.draw_text('buttonB {0}'.format(self.gd.gc.buttonB()),50,20,color.ALICE_BLUE,font_size=8,font_name=const.GAME_FONT[1])
        #arcade.draw_text('key_code {0:3}'.format(self.key_code),50,100,color.ALICE_BLUE,font_size = 24,font_name=const.GAME_FONT[1])
        arcade.draw_text('to serve press button  "B"',250,150,color.ALICE_BLUE,font_size=32,width=700,align='center',font_name=const.GAME_FONT[0])
        arcade.set_viewport(0,const.SCREEN_WIDTH,5,const.SCREEN_HEIGHT - 5)      
    
    def update(self,delta_time):
        self.gd.backgnd.update()
        self.paddle.update(self.gd.gc.axisX())
        self.ball.update()

    def on_key_press(self, symbol: int, modifiers: int):
        self.key_code = symbol


