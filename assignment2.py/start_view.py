"""
python BREAK_OUT 
start_view.py
krbergerstck june ,2020
"""

import const
import pyglet
import arcade
from arcade import color
import random

from GAMEDATA import gameData
from background import Background
from fps import FPS

class startView(arcade.View):
    def __init__(self):
        super().__init__()
        self.gd = None                  # reference to the game data
        self.fps = FPS()
        self.counter = 0
        self.time_delta = 0

    def setup(self,game_data):
        self.gd = game_data
        arcade.set_background_color(color.ALABAMA_CRIMSON)        
  
    def on_show(self):
        self.fps.reset()
        arcade.set_background_color(const.SCREEN_COLOR)

    def on_draw(self):
        # This command should happen before we start drawing. It will clear
        # the screen to the background color, and erase what we drew last frame.            
        arcade.start_render()
        self.gd.backgnd.draw()
        arcade.draw_text(const.SCREEN_TITLE,425,700,color.GREEN,font_size=48,align='center',width=350,font_name=const.GAME_FONT[0]) 
        arcade.draw_text('HIGH SCORES',425,600,color.ALABAMA_CRIMSON,font_size=32,width=350,align='center',font_name=const.GAME_FONT[0])
        self.gd.high_scores.render(475,500,color.ALICE_BLUE,const.GAME_FONT[0])
        self.gd.render_score(const.SCREEN_WIDTH-150,const.SCREEN_HEIGHT-35,color.ALICE_BLUE,24,const.GAME_FONT[0])
        arcade.draw_text('to start press button  "B"',250,150,color.ALICE_BLUE,font_size=24,width=700,align='center',font_name=const.GAME_FONT[1])
        arcade.draw_text('FPS{0:3}'.format(self.fps.get()),20,20,color.ALICE_BLUE,font_size=12,font_name=const.GAME_FONT[1])
        #arcade.draw_text('buttonB {0}'.format(self.gd.gc.buttonB()),50,40,color.ALICE_BLUE,font_size=8,font_name=const.GAME_FONT[1])
        arcade.set_viewport(0,const.SCREEN_WIDTH,5,const.SCREEN_HEIGHT - 5) 
    
    def update(self,delta_time):
        self.gd.backgnd.update()
        self.fps.update(delta_time)
        if self.gd.gc.buttonB():
            self.gd.show_view(self.gd.select_view)

    def on_key_press(self, symbol: int, modifiers: int):
        if symbol == 32 or symbol == 98:
            self.gd.show_view(self.gd.select_view)
    