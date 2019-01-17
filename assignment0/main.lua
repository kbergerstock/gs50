--[[
    GD50 2018
    Pong Remake

    -- Main Program --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Originally programmed by Atari in 1972. Features two
    paddles, controlled by players, with the goal of getting
    the ball past your opponent's edge. First to 10 points wins.

    This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on
    modern systems.

    modified by Keith R. Bergerstock aug/2018
    converted to love engine version 11.1
    requires push version 0.3
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals Class love Paddle Ball sign
-- luacheck: globals VIRTUAL_WIDTH VIRTUAL_HEIGHT PADDLE_SPEED

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'lib/push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'Paddle'

-- our Ball class, which isn't much different than a Paddle structure-wise
-- but which will mechanically function very differently
require 'Ball'

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- paddle movement speed
PADDLE_SPEED = 200

--[[
    Called just once at the beginning of the game; used to set up
    game objects, variables, etc. and prepare the game world.
]]
function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the title of our application window
    love.window.setTitle('Pong')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- initialize our player paddles; make them global so that they can be
    -- detected by other functions and modules
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    AIplayer1 = false
    AIplayer2 = false

    -- place a ball in the middle of the screen
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- either going to be 1 or 2; whomever is scored on gets to serve the
    -- following turn
    servingPlayer = 1

    -- the state of our game; can be any of the following:
    -- 1. 'start' (the beginning of the game, before first serve)
    -- 2. 'serve' (waiting on a key press to serve the ball)
    -- 3. 'play' (the ball is in play, bouncing between paddles)
    -- 4. 'done' (the game is over, with a victor, ready for restart)
    gameState = 'start'
end

--[[
    Called whenever we change the dimensions of our window, as by dragging
    out its bottom corner, for example. In this case, we only need to worry
    about calling out to `push` to handle the resizing. Takes in a `w` and
    `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Called every frame, passing in `dt` since the last frame. `dt`
    is short for `deltaTime` and is measured in seconds. Multiplying
    this by any changes we wish to make in our game will allow our
    game to perform consistently across all hardware; otherwise, any
    changes we make will be applied as fast as possible and will vary
    across system hardware.
]]
function love.update(dt)
    if gameState == 'play' then
        -- detect ball collision with paddles, reversing dx if true and
        -- slightly increasing it, then altering the dy based on the position
        -- at which it collided, then playing a sound effect

        if ball:collides(player1) then
            ball:handlePaddleCollision( player1.x + ball.width + 1)
            sounds['paddle_hit']:play()
        end

        if ball:collides(player2) then
            ball:handlePaddleCollision(player2.x - ball.width)
            sounds['paddle_hit']:play()
        end
        -- handle a possible wall collision
        if ball:handleWallCollision() then
            sounds['wall_hit']:play()
        end

        -- if we reach the left edge of the screen, go back to serve
        -- and update the score and serving player
        if ball.x < 0 then
            player2:incScore()
            sounds['score']:play()

            -- if we've reached a score of 10, the game is over; set the
            -- state to done so we can show the victory message
            if player2:Won() then
                winningPlayer = 2
                gameState = 'done'
            else
                servingPlayer = 1
                gameState = 'serve'
            end
            -- places the ball in the middle of the screen, no velocity
            ball:reset()
        end

        -- if we reach the right edge of the screen, go back to serve
        -- and update the score and serving player
        if ball.x > VIRTUAL_WIDTH then
            player1:incScore()
            sounds['score']:play()

            -- if we've reached a score of 10, the game is over; set the
            -- state to done so we can show the victory message
            if player1:Won() then
                winningPlayer = 1
                gameState = 'done'
            else
                servingPlayer = 2
                gameState = 'serve'
            end
            -- places the ball in the middle of the screen, no velocity
            ball:reset()
        end
    end

    --
    -- paddles can move no matter what state we're in
    --
    -- player 1
    if AIplayer1 then
        -- AI move paddle
        player1:track(ball)
    else
        -- player move paddle
        player1:move('w','s')
    end

    -- player 2
    if AIplayer2 then
        player2:track(ball)
    else
        player2:move('up','down')
    end

    -- update our ball based on its DX and DY only if we're in play state;
    -- scale the velocity by dt so movement is frame rate independent
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
   end

--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
    -- `key` will be whatever key this callback detected as pressed
    if key == 'escape' then
        -- the function LÖVE2D uses to quit the application
        love.event.quit()
    -- if we press enter during either the start or serve phase, it should
    -- transition to the next appropriate state
    elseif key == 'space' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            winningPlayer = 0
            player1:resetPos()
            player2:resetPos()
            -- serve the ball
            ball:handleServe(servingPlayer)
            gameState = 'play'
        elseif gameState == 'done' then
            -- game is simply in a restart phase here, but will set the serving
            -- player to the opponent of whomever won for fairness!
            gameState = 'serve'
            ball:reset()
            -- decide serving player as the opposite of who won
            if player1:Won() then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
            -- reset scores to 0
            player1:resetScore()
            player2:resetScore()
        end
    elseif key == '1' then
        AIplayer1 = not AIplayer1
        player1:resetPos()
    elseif key == '2' then
        AIplayer2 = not AIplayer2
        player2:resetPos()
    end
end
--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')

    -- this function changed for love v 11 parameters are beetween 0-1
    love.graphics.clear(0.156, 0.176,0.204, 1)

    -- render different things depending on which part of the game we're in
    -- since no message is displaued for paly state case is not needed
    if gameState == 'start' then
        displayStart()
    elseif gameState == 'serve' then
        displayServe(servingPlayer)
    elseif gameState == 'done' then
        displayWinner(winningPlayer)
    end

    -- show the score before ball is rendered so it can move over the text
    displayScore()

    player1:render()
    player2:render()
    ball:render()

    -- display FPS for debugging; simply comment out to remove
    displayFPS()

    -- end our drawing to push
    push:apply('end')
end
--Simple function for rendering the scores.
function displayScore()
    -- score display
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2.score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end
-- Renders the current FPS.
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
-- renders start msg
function displayStart()
    -- UI messages
    love.graphics.setFont(smallFont)
    love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
    if AIplayer1 then
        love.graphics.setColor(0, 255, 0, 255)
    else
        love.graphics.setColor(255,255, 255, 255)
    end
    love.graphics.printf('Press 1 for compter player one', 0, 20, VIRTUAL_WIDTH, 'center')
    if AIplayer2 then
        love.graphics.setColor(0, 255, 0, 255)
    else
        love.graphics.setColor(255,255, 255, 255)
    end
    love.graphics.printf('Press 2 for compter player two', 0, 30, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255,255, 255, 255)
    love.graphics.printf('Press SpaceBar to begin!', 0, 40, VIRTUAL_WIDTH, 'center')
end
-- renders serve message
function displayServe(player)
    -- UI messages
    love.graphics.setFont(smallFont)
    love.graphics.printf('Player ' .. tostring(player) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press SpaceBar to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
end
-- renders done message
function displayWinner(player)
    -- UI messages
    love.graphics.setFont(largeFont)
    love.graphics.printf('Player ' .. tostring(player) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
end