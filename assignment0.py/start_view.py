# starting view

import arcade
from arcade import color
import const
import gameData
from ball import FPS
from ball import BALL
from ball import PADDLE
from serve_view import ServeView

class StartView(arcade.View):
    def __init__(self):
        """ This is run once when we switch to this view """
        super().__init__()
        self.gd = None

    def setup(self,gd):
        gd.AIplayer_1 = False
        gd.AIplayer_2 = False
        # Create your sprites and sprite lists here
        # place a ball in the middle of the screen
        gd.fps = FPS(150,166,20,20)   
        gd.ball = BALL(const.VIRTUAL_WIDTH / 2, const.VIRTUAL_HEIGHT / 2, 3, 3)
        gd.player_1 = PADDLE(5, 20, 4, 20)
        gd.player_2 = PADDLE(const.VIRTUAL_WIDTH - 5 , const.VIRTUAL_HEIGHT - 20 , 4, 20 )
        self.gd = gd

    def on_show(self):
        """ This is run once when we switch to this view """
        #tbd try catch clause
        arcade.set_background_color(const.SCREEN_COLOR)        

    def on_draw(self):
        """ render the view """
        arcade.start_render()
        if self.gd == None:
            arcade.draw_text("game data uninitialized",20,500,color.RED,align='center',font_size=50)
        else:    
            msg = 'WELCOME to PONG'
            arcade.draw_text(msg,20,600,color.ANDROID_GREEN,width=const.MSG_WIDTH,align='center',font_size=32,font_name=const.GAME_FONT)
            if self.gd.AIplayer_1: msg = 'Press 1 for user player one'
            else : msg = 'Press 1 for compter player one'
            arcade.draw_text(msg,20,560,color.ARMY_GREEN,width=const.MSG_WIDTH,align='center',font_size=20,font_name=const.GAME_FONT)
            if self.gd.AIplayer_2: msg = 'Press 2 for user player two'
            else : msg = 'Press 2 for compter player two'
            arcade.draw_text(msg,20,535,color.ARMY_GREEN,width=const.MSG_WIDTH,align='center',font_size=20,font_name=const.GAME_FONT)
            msg = 'Press SpaceBar to begin!'
            arcade.draw_text(msg,20,510,color.ARMY_GREEN,width=const.MSG_WIDTH,align='center',font_size=20,font_name=const.GAME_FONT)        

    def on_key_press(self, key_code, key_modifiers):
        """ process event signals """
        if key_code == 49:
            self.gd.AIplayer_1 = not self.gd.AIplayer_1

        elif key_code == 50:
            self.gd.AIplayer_2 = not self.gd.AIplayer_2

        elif key_code == 32: 
            self.gd.serve_view.setup(self.gd)
            self.window.show_view(self.gd.serve_view)