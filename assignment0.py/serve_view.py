# serve view

import arcade
from arcade import color
import const
import gameData
from ball import FPS
from ball import BALL
from ball import PADDLE
from game_view import GameView
from ball import FPS

class ServeView(arcade.View):
    def __init__(self):
        """ This is run once when we switch to this view """
        super().__init__()
        self.gd  = None

    def setup(self,gd):
        self.gd  = gd

    def on_show(self):
        """ This is run once when we switch to this view """
        arcade.set_background_color(const.SCREEN_COLOR)        

    def on_draw(self):
        """ render the view """
        arcade.start_render()
        dl = 560
        if self.gd.point:
            msg = 'point for player {0}'.format(self.gd.id)
            arcade.draw_text(msg,20,dl,color.ANDROID_GREEN,width=const.MSG_WIDTH,align='center',font_size=32,font_name=const.GAME_FONT)
            dl -= 40
        pd = 3 - self.gd.id if self.gd.point else self.gd.id    
        msg = "Player {0} to serve".format(pd) 
        arcade.draw_text(msg,20,dl,color.ANDROID_GREEN,width=const.MSG_WIDTH,align='center',font_size=32,font_name=const.GAME_FONT)            
        dl -= 40
        msg = 'Press space bar to serve!'
        arcade.draw_text(msg,20,dl,color.ARMY_GREEN,width=const.MSG_WIDTH,align='center',font_size=20,font_name=const.GAME_FONT)

    def on_key_press(self, key_code, key_modifiers):
        """ process event signals """
        if key_code == 32: 
            self.gd.game_view.setup(self.gd)
            self.window.show_view(self.gd.game_view)