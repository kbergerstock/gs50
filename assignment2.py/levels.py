# levels.py
# k.r.bergerstock
# python breakout project

import const
import arcade

def level_1(gd,n = 3):
    c = [5,9,13,16]
    colors = []
    for i in range(4):
        for d in c:
            colors.append(d)
    w = const.BRICK_WIDTH * const.BRICK_SCALE 
    h = const.BRICK_HEIGHT * const.BRICK_SCALE
    cx = 75 + w / 2
    cy = 500 + h / 2
    bricks = arcade.SpriteList(True)
    for i in range(n):
        for j in range(14):
            brick = arcade.Sprite()
            brick.append_texture(gd.bricks[colors[j]])
            brick.set_position(cx,cy)
            brick.set_texture(0)
            brick.scale = const.BRICK_SCALE
            bricks.append(brick)
            cx += w
        cx = 75 + w / 2    
        cy += 2 * h
    return bricks
    