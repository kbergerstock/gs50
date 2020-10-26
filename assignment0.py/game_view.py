"""
pong.py main file
krbergerstck june ,2020
"""
import const
import arcade
from arcade import color
from arcade import key
import random
import gameData
from ball import FPS
from ball import BALL
from ball import PADDLE

class GameView(arcade.View):
    """
    Main application class.
    """

    def __init__(self):
        super().__init__()

        random.seed()

        self.paddle_hit = arcade.Sound('sounds/paddle_hit.wav')
        self.score = arcade.Sound('sounds/score.wav')
        self.wall_hit = arcade.Sound('sounds/wall_hit.wav')
        arcade.play_sound(self.paddle_hit)
        # If you have sprite lists, you should create them here,
        # and set them to None
        self.gd  = None

    def setup(self,gd):
        pd = 3 - gd.id  if gd.point else gd.id
        gd.ball.Serve(pd)
        self.gd = gd
        
    def on_draw(self):
        """
        Render the screen.
        """
        # This command should happen before we start drawing. It will clear
        # the screen to the background color, and erase what we drew last frame.
        arcade.start_render()
        self.gd.fps.render()
        self.gd.renderScore()
        self.gd.ball.render()
        self.gd.player_1.render()
        self.gd.player_2.render()

    def on_update(self, delta_time):
        """
        All the logic to move, and the game logic goes here.
        Normally, you'll call update() on the sprite lists that
        need it.
        """
        self.gd.fps.update(delta_time)
        self.gd.ball.update(delta_time)
        if self.gd.AIplayer_1: self.gd.player_1.track(self.gd.ball)
        if self.gd.AIplayer_2: self.gd.player_2.track(self.gd.ball)
        self.gd.player_1.update(delta_time)
        self.gd.player_2.update(delta_time)

        if self.gd.ball.handleWallCollision():
            arcade.play_sound(self.wall_hit)

        if self.gd.ball.collides(self.gd.player_1):
            self.gd.ball.handlePaddleCollision(self.gd.player_1)
            arcade.play_sound(self.paddle_hit)
            
        elif self.gd.ball.collides(self.gd.player_2):
            self.gd.ball.handlePaddleCollision(self.gd.player_2)
            arcade.play_sound(self.paddle_hit)                

        elif self.gd.ball.Scored(self.gd.player_1):
            self.handleScored(self.gd.player_1)
            
        elif self.gd.ball.Scored(self.gd.player_2):
            self.handleScored(self.gd.player_2)
    
    def handleScored(self,player):
        arcade.play_sound(self.score)
        player.scored()
        self.gd.id = player.id
        self.gd.point  = True
        if player.getScore() >= 11 :
            self.gd.game_over_view.setup(self.gd)
            self.window.show_view(self.gd.game_over_view)            
        else:
            self.gd.serve_view.setup(self.gd)
            self.window.show_view(self.gd.serve_view)

    def on_key_press(self, key_code, key_modifiers):
        """
        Called whenever a key on the keyboard is pressed.

        For a full list of keys, see:
        http://arcade.academy/arcade.key.html
        """
        if key_code == 97 and not self.gd.AIplayer_1:   # key code for 'a'
            self.gd.player_1.move(1,0)             # stop the down movement
            self.gd.player_1.move(0,1)             # start the up movement

        elif key_code == 100 and not self.gd.AIplayer_1 :  # key code for 'd'
            self.gd.player_1.move(0,0)             # stop the up movment
            self.gd.player_1.move(1,1)             # start the down movement           
            
        elif key_code == 65361 and not self.gd.AIplayer_2:   # key code for 'left'
            self.gd.player_2.move(1,0)
            self.gd.player_2.move(0,1)

        elif key_code == 65363 and not self.gd.AIplayer_2:   # key code for 'right'
            self.gd.player_2.move(0,0)
            self.gd.player_2.move(1,1)              

    def on_key_release(self, key_code, key_modifiers):
        """
        Called whenever the user lets off a previously pressed key.
        """
        # stop the motion that coresponds to the key code
        if key_code == 97 and not self.gd.AIplayer_1:
            self.gd.player_1.move(0,0)
            
        elif key_code == 100 and not self.gd.AIplayer_1:
            self.gd.player_1.move(1,0) 

        elif key_code == 65361 and not self.gd.AIplayer_2:
            self.gd.player_2.move(0,0)
            
        elif key_code == 65363 and not self.gd.AIplayer_2:
            self.gd.player_2.move(1,0) 