"""
BREAK_OUT.py main file
krbergerstck june ,2020

"""

import arcade

from GAMEDATA import gameData
from hiscores import hiscores
from background import Background
from start_view import startView      
from select_view import selectView
   
def main():
    """ Main method """
    gd = gameData()
    gd.backgnd = Background()
    gd.high_scores = hiscores()

    # create the games starting function
    # store a refence to start in game data
    # this is a linked list with the tail pointing to the head
    gd.start_view =  startView()
    gd.select_view = selectView()
    # store a refence to game data in start_view
    gd.start_view.setup(gd)
    gd.select_view.setup(gd)
    # activate the starting view 
    gd.show_view(gd.start_view)
    
    # execute the game engine
    arcade.run()

if __name__ == "__main__":
    main()