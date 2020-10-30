# fps.py

class FPS:
    def __init__(self):
        self.__fps = 0
        self.__counter = 0
        self.__time_delay = 0.0

    def update(self,delta_time):
        self.__counter += 1    
        self.__time_delay += delta_time
        if self.__time_delay >= 1.0:
            self.__fps = self.__counter
            self.__counter = 0
            self.__time_delay -= 1.0

    def reset(self):
        self.__counter = 0
        self.__time_delay = 0.0

    def get(self):
        return self.__fps
