# game over view

import const
import arcade
from   arcade   import color
from   gameData import gameData

class GameOver(arcade.View):

    def __init__(self):
        super().__init__()
        self.gd = None

    def setup(self, gd):
        self.gd  = gd

    def on_show(self):
        pass
    
    def on_draw(self):
        arcade.start_render()
        self.gd.renderSCore()
        dl = 560
        msg = 'point for player {0}'.format(self.gd.id)
        arcade.draw_text(msg,20,dl,color.ANDROID_GREEN,width=const.MSG_WIDTH,align='center',font_size=32,font_name=const.GAME_FONT)
        dl -= 40
        msg = "Player {0} ** !! WON !!** ".format(self.gd.id) 
        arcade.draw_text(msg,20,dl,color.ANDROID_GREEN,width=const.MSG_WIDTH,align='center',font_size=32,font_name=const.GAME_FONT)            
        dl -= 40
        msg = 'Press space bar to restart!'
        arcade.draw_text(msg,20,dl,color.ARMY_GREEN,width=const.MSG_WIDTH,align='center',font_size=20,font_name=const.GAME_FONT)        

    def on_key_press(self, key_code, key_modifiers):
        if key_code == 32: 
            self.gd.serve_view.setup(self.gd)
            self.window.show_view(self.gd.serve_view)