"""
BREAK_OUT.py main file
krbergerstck june ,2020

"""

import arcade

from game_data import gameData
from hiscores import hiscores
from background import Background
from start_view import startView      
from select_view import selectView
from level_view import levelView
from ball import BALL
from paddle import PADDLE

# from memory_profiler import profile
# @profile
def main():
    """ Main method """
    gd = gameData()
    gd.backgnd = Background()
    gd.ball = BALL()
    gd.paddle = PADDLE()
    gd.high_scores = hiscores()

    # create the games starting function
    # store a refence to start in game data
    # this is a linked list with the tail pointing to the head
    gd.start_view =  startView(gd)
    gd.select_view = selectView(gd)
    gd.level_view = levelView(gd)
    # activate the starting view 
    gd.show_view(gd.start_view)
    
    # execute the game engine
    arcade.run()

if __name__ == "__main__":
    main()