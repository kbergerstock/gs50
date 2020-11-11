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
    def __init__(self,game_data):
        super().__init__()
        self.gd = None                      # reference to the game data
        self.key_code = 0
        self.gd = game_data
        self.setup()
        self.gd.level = 1
        self.gd.msg = 1

    def setup(self):
        self.gd.bricks = levels.level_1(self.gd)
        self.gd.ball.createSprite(self.gd)
        self.gd.paddle.createSprite(self.gd)
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
        self.gd.render_score(const.SCREEN_WIDTH-150,const.SCREEN_HEIGHT-35,color.ALICE_BLUE,24,const.GAME_FONT[0])
        if self.gd.msg == 1:
            arcade.draw_text('PRESS UP/DN TO CHANGE PADDLE_COLOR',200,150,color.ALICE_BLUE,font_size=32,width=800,align='center',font_name=const.GAME_FONT[0])
            arcade.draw_text('PRESS <SPACE> OR <B> TO SELECT',250,100,color.ALICE_BLUE,width=700,align='center',font_size=32,font_name=const.GAME_FONT[0])
        elif self.gd.msg == 2:
            arcade.draw_text('LEVEL {0}'.format(self.gd.level),250,300,color.ALICE_BLUE,font_size=48,width=700,align='center',font_name=const.GAME_FONT[0])
            arcade.draw_text('LIVES REMAINING {0}'.format(self.gd.health),250,200,color.ALICE_BLUE,font_size=32,width=700,align='center',font_name=const.GAME_FONT[0])
            arcade.draw_text('TO SERVE PRESS <SPACE> OR <B>',250,100,color.ALICE_BLUE,font_size=32,width=700,align='center',font_name=const.GAME_FONT[0])
        elif self.gd.msg == 3:
            self.gd.show_view(self.gd.level_view)
        else:
            pass    

        arcade.set_viewport(0,const.SCREEN_WIDTH,5,const.SCREEN_HEIGHT - 5)      
    
    def update(self,delta_time):
        self.gd.backgnd.update()
        if self.gd.gc.buttonB():
            self.gd.msg += 1 

    def on_key_press(self, symbol: int, modifiers: int):
        if symbol == 32 or symbol == 98:
            self.gd.msg += 1
        elif symbol == 65362 and self.gd.msg == 1:
            self.gd.paddle.inc_texture()
        elif symbol == 65364 and self.gd.msg == 1:       
            self.gd.paddle.dec_texture()

        self.key_code = symbol