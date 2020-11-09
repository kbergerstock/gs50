"""
python BREAK_OUT 
background.py
krbergerstck june ,2020
"""

import const
import arcade
from arcade import color

class LeftMargin():
    def __init__(self):
        self.left = 0

    def Update(self,limit):
        self.left -= 1
        if self.left <= -limit:
            self.left = 0

    def get(self):
        return self.left

class Background():
    def __init__(self):
        self.bkgnd = None               # reference to bkgnd sprite list
        self.left = LeftMargin() 
        self.setup()

    def setup(self):
        ''' create the background sprite list '''
        self.bkgnd = arcade.SpriteList()
        sprite = arcade.Sprite('resources/background1.png',4.0)
        sprite.position = sprite.width/2,const.SCREEN_HEIGHT - sprite.height/2 - 5
        self.bkgnd.append(sprite)
        sprite = arcade.Sprite('resources/background1.png',4.0)
        sprite.position = (sprite.width * 3)/2,const.SCREEN_HEIGHT - sprite.height/2 - 5
        self.bkgnd.append(sprite) 

    def draw(self):
        ''' draw the moving back ground '''
        self.bkgnd.draw()           

    def update(self): 
        ''' update the position of the background sprites '''
        sw = 0
        self.left.Update(const.SCREEN_WIDTH)
        for sprite in self.bkgnd :
            sprite.left = sw + self.left.get()
            sw += const.SCREEN_WIDTH   

