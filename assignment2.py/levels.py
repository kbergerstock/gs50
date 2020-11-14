# levels.py
# k.r.bergerstock
# python breakout project

import const
import arcade

class BRICK(arcade.Sprite):
    def __init__(self):
        super().__init__()
        self.__tier = 0
        self.__points = 0
        self.__hits =  0

        def __get__points(self):
            return self.__points
        def __set__points(self,points):
            self.__points = points
        points = property (__get__points, __set__points)

        def __get__tier(self):
            return self.__tier if self.__tier > 0 else 0
        def __set__tier(self,tier):
            if tier <  0:
                tier =  0
            elif tier > 7:
                tier = 7
            self.__tier = tier
        tier = property(__get__tier,__set__tier)

        def __get__hits(self):
            return self.__hits if self.__hits > 0 else 0
        def __set__hits(self,hits):
            if hits < 0: 
                hits = 0
            elif hits > 4:
                hits = 4   
            self.__hits = hits 
        hits = property(__get__hits,__set__hits)    


def level_1(gd,n = 8):
    w = const.BRICK_WIDTH * const.BRICK_SCALE 
    h = const.BRICK_HEIGHT * const.BRICK_SCALE
    cx = 1+ w / 2
    cy = 400 
    bricks = arcade.SpriteList(True)
    for i in range(n):
        for j in range(14):
            brick = BRICK()
            brick.tier = i
            brick.hits = 1 + i//2
            brick.score = 1 + i//2
            brick.textures = gd.textures['bricks']
            brick.set_position(cx,cy)
            brick.set_texture(i//2*4)
            brick.scale = const.BRICK_SCALE
            bricks.append(brick)
            cx += w
        cx = 1+ w / 2    
        cy += h + 1
    return bricks
    