import arcade
import const
from gameData   import gameData
from start_view import StartView
from serve_view import ServeView
from game_view  import GameView
from game_over_view import GameOver

def main():
    """ Main method """

    gd = gameData()

    window = arcade.Window(const.SCREEN_WIDTH, const.SCREEN_HEIGHT, const.SCREEN_TITLE)
    gd.start_view = StartView()
    gd.serve_view = ServeView()
    gd.game_view  = GameView()
    gd.game_over_view  = GameOver()
    # install a reference to the game data in the starting view
    gd.start_view.setup(gd)
    window.show_view(gd.start_view)
    arcade.run()

if __name__ == '__main__':
    main()
