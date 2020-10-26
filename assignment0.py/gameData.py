# gameData.py
import const
import arcade
from arcade import color

class gameData():

    def __init__(self):
        self.AIplayer_1 = False
        self.AIplayer_2 = False
        self.point  = False
        self.id  = 1
        self.fps = None
        self.ball = None
        self.player_1 = None
        self.player_2 = None
        self.serve_view  = None
        self.game_view  = None
        self.game_over_view = None

    def renderScore(self):
        s1 = self.player_1.getScore()
        s2 = self.player_2.getScore()
        msg = " {0} : {1}".format(s1,s2 )
        arcade.draw_text(msg,20,600,color.ANDROID_GREEN,width=const.MSG_WIDTH,align='center',font_size=50,font_name=const.GAME_FONT)

  