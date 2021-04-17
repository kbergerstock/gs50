"""
python BREAK_OUT 
level_view.py
krbergerstck june ,2020
"""

import const
import arcade
from arcade import color
import random
#from game_data import gameData
from background import Background
from paddle import PADDLE 
from ball import BALL

class levelView(arcade.View):
    def __init__(self,game_data):
        super().__init__()
        self.gd = None                  # reference to the game data
        self.gd = game_data
        self.dir = 0

    def setup(self):
        pass
 
    def on_show(self):
        self.dir = 0
        arcade.set_background_color(const.SCREEN_COLOR)
    
    def on_draw(self):
        # This command should happen before we start drawing. It will clear
        # the screen to the background color, and erase what we drew last frame.            
        arcade.start_render()
        self.gd.backgnd.draw()
        self.gd.sprites.draw()
        self.gd.render_score(const.SCREEN_WIDTH-150,const.SCREEN_HEIGHT-35,color.ALICE_BLUE,24,const.GAME_FONT[0])
        arcade.set_viewport(0,const.SCREEN_WIDTH,5,const.SCREEN_HEIGHT - 5)      
    
    def update(self,delta_time):
        self.gd.backgnd.update()
        if self.dir == 0:
            self.dir = self.gd.gc.axisX()
        self.gd.paddle.update(self.dir)
        if self.gd.ball.update(self.gd.paddle,self.gd.bricks):
            self.gd.msg = 2
            self.gd.show_view(self.gd.select_view)

    def on_key_press(self, symbol: int, modifiers: int):
        if symbol == 65361:
            self.dir = -1
        elif symbol == 65363:
            self.dir = 1

    def on_key_release(self, _symbol: int, _modifiers: int):
        if _symbol == 65361 or _symbol == 65363:
            self.dir = 0


