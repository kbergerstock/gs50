# ball.py
import arcade
import const
import math

class BALL(arcade.Sprite):
    def __init__(self):
        super().__init__()            
        self.speed = const.BALL_VELOCITY
        self.scale = const.BALL_SCALE
        self.angle = 75
        self.dx = 0
        self.dy = 0
        self.update_dx_dy()

    def createSprite(self,gd):
        for i in range(7):
            self.append_texture(gd.textures['balls'][i])
        self.set_position(600,55)
        self.set_texture(2)

    def update_dx_dy(self):
        self.angle *= -1
        rad = self.angle * math.pi / 180.0
        self.dx = self.speed * math.cos(rad)
        self.dy = self.speed * math.sin(rad)

    def move(self):
        self.center_x += self.dx
        self.center_y += self.dy

    def update(self,paddle,bricks):
        """
         checks ball for boundry conditions and collisions
         returns true if out of bounds
        """
        collision  = False
        h2 = self.height / 2
        w2 = self.width / 2
        #  screen constraints
        TOP = const.SCREEN_HEIGHT - 5
        BOTTOM = 5
        LEFT = 1
        RIGHT = const.SCREEN_WIDTH - 1
        
        if self.top >= TOP :
            self.center_y = TOP - h2
            collision = True  
        elif self.bottom <= BOTTOM :
            #out of bounds
            self.angle = 75
            self.dx = 0
            self.dy = 0 
            self.set_position(paddle.center_x,55)
            self.set_texture(2)
            self.update_dx_dy()
            return True
                      
        if self.right >= RIGHT:
            self.center_x = RIGHT - w2 
            self.speed *= -1
            collision = True          
        elif self.left <= LEFT:    
            self.center_x = LEFT + w2  
            self.speed *= -1
            collision = True

        if self.collides_with_sprite(paddle):
            if self.center_y < paddle.top and self.center_y > paddle.bottom:
                self.speed *= -1
            collision = True

        _bricks = self.collides_with_list(bricks)
        if _bricks:
            brick = _bricks[0]

            if self.center_y < brick.center_y:
                self.center_y = brick.bottom - w2 - 1
            else:
                self.center_y = brick.top + w2 + 1  
                
            if self.center_y >= brick.bottom and self.center_y < brick.top:
                self.speed *= -1
            collision = True

        if collision: 
            self.update_dx_dy()
        self.move()            
        return False