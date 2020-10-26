# game controller module
# k.r.bergerstock @ oct,2020

import pyglet.input

class game_device:

    @classmethod    
    def setup(cls):
        jss = pyglet.input.get_joysticks()
        if jss: 
            gc = jss[0]
            if gc:
                gc.open()
                return gc
            else:
                return None
        else:
            return None

def __convert__(value):
    if value > 0.6:
        return 1
    elif value < -0.6:
        return -1
    else:
        return 0  

class game_controller:
    def __init__(self,__gc__):
        self.gc = __gc__

    def buttonX(self):
        return self.gc.buttons[0]

    def buttonA(self):
        return self.gc.buttons[1]

    def buttonB(self):
        return self.gc.buttons[2]        

    def buttonY(self):
        return self.gc.buttons[3]

    def axisX(self):
        return __convert__(self.gc.x)

    

