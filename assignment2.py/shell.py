# pyglet shell 
import pyglet
from pyglet import gl

def set_background_color(r,g,b):
    """
    This specifies the background color of the window.
    """

    gl.glClearColor(r/255, g/255, b/255, 1)



class AppWindow(pyglet.window.Window):
    def __init__(self):
        super(AppWindow,self).__init__(caption = ' new window ')

        self.label = pyglet.text.Label('hello world',
                        font_name = 'resources\atari',
                        font_size = 50,
                        x = self.width//2,
                        y = self.height//2,
                        anchor_x='center',
                        anchor_y='center')

    def on_show(self):
        set_background_color(0,0,160)
        
    def on_draw(self):
        self.clear()
        self.label.draw()

def main():
    win = AppWindow()
    pyglet.app.run()

if __name__ == '__main__':
    main()