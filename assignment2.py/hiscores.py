# a module to handle the high scores of a game
# k.r.bergerstock @ oct 2020

import const
import arcade
from arcade import color

class hiscores():
    def __init__(self):
        # create the hi score table
        self.hi_scores = []
        for i in range(10):
            self.hi_scores.append([i+1,'AAA',369 - i*i])

    def write(self,file_name):
        pass

    def read(self,file_name):
        pass

    def render(self,x,y,Color,Font):
        ''' display the hi score table '''
        for  e in self.hi_scores:
            arcade.draw_text("{0:>2}".format(e[0]),x,y,Color,font_size=18,font_name=Font)
            arcade.draw_text("{0:<3}".format(e[1]),x+75,y,Color,font_size=18,font_name=Font)
            arcade.draw_text("{0:>8}".format(e[2]),x+150,y,Color,font_size=18,font_name=Font)
            y -= 25
