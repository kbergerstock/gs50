"""
BREAK_PUYT.py main file
krbergerstck june ,2020

If Python and Arcade are installed, this example can be run from the command line with:
python -m arcade.examples.starting_template
"""
import const
import arcade
from arcade import color
import random

class MyGame(arcade.Window):
    """
    Main application class.p
    """

    def __init__(self, title):
        super().__init__(const.SCREEN_WIDTH,const.SCREEN_HEIGHT, title)

        random.seed()

        arcade.set_background_color(const.SCREEN_COLOR)
        
        # load sound resources
        self.snds = {}
        self.snds['music']  = arcade.Sound('resources/music.wav')
        
    
        # If you have sprite lists, you should create them here,
        # and set them to None


    def setup(self):
        # Create your sprites and sprite lists here
        # place a ball in the middle of the screen
        arcade.play_sound(self.snds['music'])
        pass

        
    def on_draw(self):
        """
        Render the screen.
        """
        # This command should happen before we start drawing. It will clear
        # the screen to the background color, and erase what we drew last frame.
        arcade.start_render()

        arcade.draw_text('BREAK OUT',550,350,color.BLUE,font_size=32,font_name=const.GAME_FONT[0])
        arcade.finish_render()

    def on_update(self, delta_time):
        """
        All the logic to move, and the game logic goes here.
        Normally, you'll call update() on the sprite lists that
        need it.
        """
        pass


    def on_key_press(self, key_code, key_modifiers):
        """
        Called whenever a key on the keyboard is pressed.

        For a full list of keys, see:
        http://arcade.academy/arcade.key.html
        """
            
        if key_code == 65361 and not self.AIplayer_2:   # key code for 'left'
            pass

        elif key_code == 65363 and not self.AIplayer_2:   # key code for 'right'
            pass

        elif key_code == 32:  
            if self.game_state == const.START:
                self.id = 1
            

    def on_key_release(self, key_code, key_modifiers):
        """
        Called whenever the user lets off a previously pressed key.
        """
        # stop the motion that coresponds to the key code
        if key_code == 65361 and not self.AIplayer_2:
            pass
            
        elif key_code == 65363 and not self.AIplayer_2:
            pass

    def on_mouse_motion(self, x, y, delta_x, delta_y):
        """
        Called whenever the mouse moves.
        """
        pass

    def on_mouse_press(self, x, y, button, key_modifiers):
        """
        Called when the user presses a mouse button.
        """
        pass

    def on_mouse_release(self, x, y, button, key_modifiers):
        """
        Called when a user releases a mouse button.
        """
        pass

    def renderScore(self):
       pass


def main():
    """ Main method """
    game = MyGame(const.SCREEN_TITLE)
    game.setup()
    arcade.run()

if __name__ == "__main__":
    main()