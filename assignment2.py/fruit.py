class Fruit:
    name = 'Fruitas'

    @classmethod
    def printName(cls):
        print('The name is:', cls.name)

Fruit.printName()

apple = Fruit()
berry = Fruit()

Fruit.printName()
apple.printName()
berry.printName()
