# ball.py
import arcade
import const
import math

class BALL(arcade.Sprite):
    def __init__(self):
        super().__init__()            
        self.speed = const.BALL_VELOCITY
        self.scale = const.BALL_SCALE
        self.angle = 22
        self.dx = 0
        self.dy = 0
        self.update_dx_dy()

    def update_dx_dy(self):
        rad = self.angle * math.pi / 180.0
        self.dx = self.speed * math.cos(rad)
        self.dy = self.speed * math.sin(rad)

    def move(self):
        self.center_x += self.dx
        self.center_y += self.dy

    def update(self):
        top = self.center_y + self.height / 2
        bottom = self.center_y - self.height /2
        left = self.center_x - self.width /2
        right = self.center_x + self.width / 2
        
        if top >= const.SCREEN_HEIGHT - 5 :
            self.angle *= -1
            self.update_dx_dy()    
        elif bottom < 5 :
            self.angle *= -1
            self.update_dx_dy()

        if right >= const.SCREEN_WIDTH  or self.left <= 1:
            self.angle *= -1
            self.speed *= -1          
            self.update_dx_dy()
        self.move()            