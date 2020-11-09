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
        self.key_code = 0

    def setup(self,game_data):
        self.gd = game_data
        self.gd.bricks = levels.level_1(game_data)
        self.gd.ball.createSprite(game_data)
        self.gd.paddle.createSprite(game_data)
        self.gd.sprites.extend(self.gd.bricks)
        self.gd.sprites.append(self.gd.ball)
        self.gd.sprites.append(self.gd.paddle)

    def on_show(self):
        arcade.set_background_color(const.SCREEN_COLOR)

    def on_draw(self):
        # This command should happen before we start drawing. It will clear
        # the screen to the background color, and erase what we drew last frame.            
        arcade.start_render()
        self.gd.backgnd.draw()
        self.gd.sprites.draw()
        #arcade.draw_text('buttonB {0}'.format(self.gd.gc.buttonB()),50,20,color.ALICE_BLUE,font_size=8,font_name=const.GAME_FONT[1])
        arcade.draw_text('key_code {0:3}'.format(self.key_code),50,100,color.ALICE_BLUE,font_size = 24,font_name=const.GAME_FONT[1])
        arcade.draw_text('PRESS UP/DN YO CHANGE PADDLE_COLOR',250,150,color.ALICE_BLUE,font_size=32,width=700,align='center',font_name=const.GAME_FONT[0])
        arcade.set_viewport(0,const.SCREEN_WIDTH,5,const.SCREEN_HEIGHT - 5)      
    
    def update(self,delta_time):
        self.gd.backgnd.update()
        if self.gd.gc.buttonB():
            self.gd.show_view(self.gd.serve_view)

    def on_key_press(self, symbol: int, modifiers: int):
        if symbol == 32 or symbol == 98:
           self.gd.show_view(self.gd.serve_view)
        elif symbol == 65532:
            pass
        elif symbol == 65534:       
            pass
        else:
            self.key_code = symbol