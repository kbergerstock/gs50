# ball.py
# k.r.bergerstock junr 2020
# object class3s for pong.py
import math
import const
import random
import arcade
from arcade import color
#######################################################################################
class SHAPE():
    """
    Generic shape clss
    """

    def __init__(self, vx, vy, vw, vh):       
        # convert virtual coordinates to screen coordinates once
        self.sx = const.translateX(vx)  # input: virtual x coordinate 
        self.sy = const.translateY(vy)  # input: virtual y coordinate
        self.w  = const.width(vw)       # input: width in virtual units
        self.h  = const.height(vh)      # input: heigth in virtual units
        self.c = (245,245,245)          # color of shape

    def color(self, k):
        self.c = k
        
    def set_sx(self, vx):
        self.sx = const.translateX(vx)

    def set_sy(self, vy):
        self.sy  = const.translateY(vy)

    def SX(self):
        return self.sx        

    def SY(self):
        return self.sy        

#######################################################################################
class VRECT(SHAPE):
    """ 
    generic rectangle shape 
    """
    def __init__(self, vx, vy, vw, vh):
        # convert virtual coordinates to screen coordinates once
        super().__init__(vx,vy,vw,vh)
        self.vx = vx
        self.vy = vy
        self.vw = vw
        self.vh = vh
        self.ox = vx                    # store start position as origin
        self.oy = vy
        self.mx = 0                     # movment components
        self.my = 0
        self.dx = 0                     # velocity components    
        self.dy = 0
        self.input = [0,0]               # input storage

    def reset(self):
        self.vx = self.ox
        self.vy = self.oy
        self.dx = 0
        self.dy = 0
        self.mx = 0
        self.my = 0

    def render(self):
        self.set_sx(self.vx)
        self.set_sy(self.vy)
        arcade.draw_rectangle_filled(self.sx,self.sy,self.w,self.h,self.c)

#######################################################################################
class FPS(SHAPE):
    def __init__(self,vx,vy,vw ,vh):
        super().__init__(vx, vy, vw, vh)
        self.t  = 0.0       
        self.n  = 0
        self.fps = 0

    def update(self, dt):
        self.t += dt
        self.n += 1
        if self.t >= 1.0:
            self.fps = self.n
            self.t -= 1.0
            self.n = 0  

    def render(self):
        szfps = 'FPS   {0}'.format(self.fps)
        arcade.draw_text(szfps,self.SX(),self.SY(),color.AFRICAN_VIOLET,font_size=20, font_name=const.GAME_FONT )

#######################################################################################
class BALL(VRECT):
    def __init__(self, vx, vy,vw ,vh):
        super().__init__(vx, vy, vw, vh)
        # condition the random generator
        for i in range(8):
            random.randrange(-15,35)
        
    #  handle a wall collision
    #  detect upper and lower screen boundary collision, playing a sound
    #  effect and reversing dy if true
    def handleWallCollision(self):
        h2 = self.vh / 2
        if self.vy <= h2:
            self.vy = h2
            self.dy *= -1
            return True
        elif self.vy >= const.VIRTUAL_HEIGHT - h2:
            self.vy = const.VIRTUAL_HEIGHT - h2            
            self.dy *= -1
            return True
        else:
            return False
     
    def update(self, dt):
        self.vx += self.dx * dt
        self.vy += self.dy * dt

    def collides(self,paddle):
        # this is modified from the AABB algrithim
        # becuse the sx,sy coordinates are the center points of the objects
        # instead of the lower left hand corner
        w = (self.vw + paddle.vw) / 2
        h = (self.vh + paddle.vh) / 2 
        if(self.vx < (paddle.vx + w)) and ((self.vx + w) > paddle.vx) and \
            (self.vy < (paddle.vy + h)) and ((self.vy + h) > paddle.vy):
            return True
        else:    
            return False    

    def handlePaddleCollision(self, player):
        self.dx = self.dx * -1.03
        if self.dx > 0:
            self.vx = player.vx + (player.vw + self.vw) / 2
        else:            
            self.vx = player.vx - (player.w + self.vw)  / 2
        # keep velocity going in the same direction, but randomize it
        self.dy = self.dy * (1 + random.randrange(-15,35) / 50 )

    # handle the ball serve
    def Serve(self, player_id):
        super().reset()
        # before switching to play, initialize ball's velocity based
        # on player who last scored
        self.dy = random.randrange(-50, 50)
        dd = 1 if player_id == 1 else -1
        self.dx = dd * random.randrange(const.BALL_SPEED_L, const.BALL_SPEED_H)

    def Scored(self,player):
        return (self.vx <= 0 and player.id == 2 )or (self.vx >= const.VIRTUAL_WIDTH and player.id  == 1)

#######################################################################################
class PADDLE(VRECT):
    def __init__(self, vx, vy, vw ,vh):
        super().__init__(vx, vy, vw, vh)
        self.paddle_speed = const.PADDLE_SPEED
        self.score = 0
        self.id = 1
        if vx > const.VIRTUAL_WIDTH / 2 :
            self.id = 2

    def reset(self):
        super().reset()
        self.dy = 0
        self.input[0] = 0
        self.input[1] = 0

    def resetScore(self):
        self.score = 0

    def scored(self):
        self.score += 1

    def getScore(self):
        return self.score

    # update the paddle position
    def update(self, dt):
        h2 = self.vh / 2.0
        self.vy += (self.dy * self.paddle_speed * dt)

        # bounds check y position
        if self.vy  <= h2:
            self.vy = h2
            self.dy = 0
        elif self.vy + h2 > const.VIRTUAL_HEIGHT:
            self.vy = const.VIRTUAL_HEIGHT - h2
            self.dy =  0

    # set the movement condition
    def move(self,key,d):
        self.input[key] = d
        # move 1 virtual pixel at a time
        if self.input[0] == 1:
            self.dy = 1
        elif self.input[1] == 1 :
            self.dy = -1
        else:   
            self.dy = 0

    # ai logic to control paddle            
    def track(self,ball):
        zy = self.vy - ball.vy            # get the difference betwwen the center points
        if zy > 1.0:                      # set  move component base on these rules
            self.dy = -1
        elif zy < -1.0:
            self.dy = 1
        else:
            self.dy = 0    
         