
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState gRSC
-- luacheck: ignore detect_and_handle_brick_collisions

-- functions to iterate over the array of bricks
function checkVictory(bricks)
    for k, brick in pairs(bricks) do
        if brick.inPlay then
            return false
        end
    end
    return true
end

-- collision code for bricks
function handle_brick_collision(ball,brick)
    -- we check to see if the opposite side of our velocity is outside of the brick;
    -- if it is, we trigger a collision on that side. else we're within the X + width of
    -- the brick and should check to see if the top or bottom edge is outside of the brick,
    -- colliding on the top or bottom accordingly

    -- left edge; only check if we're moving right, and offset the check by a couple of pixels
    -- so that flush corner hits register as Y flips, not X flips
    if ball.x + 2 < brick.x and ball.dx > 0 then

        -- flip x velocity and reset position outside of brick
        ball.dx = -ball.dx
        ball.x = brick.x - 8

    -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
    -- so that flush corner hits register as Y flips, not X flips
    elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then

        -- flip x velocity and reset position outside of brick
        ball.dx = -ball.dx
        ball.x = brick.x + 32

    -- top edge if no X collisions, always check
    elseif ball.y < brick.y then
        -- flip y velocity and reset position outside of brick
        ball.dy = -ball.dy
        ball.y = brick.y - 8
    else
       -- bottom edge if no X collisions or top collision, last possibility
        -- flip y velocity and reset position outside of brick
        ball.dy = -ball.dy
        ball.y = brick.y + 16
    end

    -- slightly scale the y velocity to speed up the game, capping at +- 150
    if math.abs(ball.dy) < 150 then
        ball.dy = ball.dy * 1.02
    end
end

function update_score(msg,brick)
    -- add to score
    -- ts == tier scale
    -- bs == brick color scale
    local s = 0
    if brick.keyBrick then
        s = math.max(1000,msg.level * 125)
        msg.breakout = true
    else
        s =  (brick.tier * 100 + brick.color * 5)
    end

    msg.score = msg.score + s

    -- trigger the brick's hit function, which removes it from play
    brick:hit()

    -- if we have enough points, recover a point of health
    if msg.score > msg.recoverPoints then
        -- can't go above 3 health
        msg.health = math.min(3, msg.health + 1)

        -- multiply recover points by 2
        msg.recoverPoints = math.min(msg.recoverPoints + 10000, msg.recoverPoints * 2)

        -- play recover sound effect
        gRSC.sounds['recover']:play()
    end
end

-- update scoring using different parameters if it is the keybrick
function handle_scoring(msg, brick)
    if brick.keyBrick then
        if msg.keyCaught then
            update_score(msg, brick)
        end
    else
        update_score(msg, brick)
    end
end

function score_bonas(msg)
    msg.score = msg.score + msg.level  * 500
end

function detect_and_handle_brick_collisions(msg)
    -- process all active balls
    for i , ball in pairs(msg.balls:getList()) do
         if ball:isActive()  then
            -- detect collision across all bricks with the ball
            for k, brick in pairs(msg.bricks) do
                if brick.inPlay then
                    if ball:collides(brick) then
                        -- change the ball movement vectors
                        handle_brick_collision(ball, brick)
                        -- update scoring
                        handle_scoring(msg,brick)
                        -- only allow colliding with one brick, for corners
                        -- break the loop on first collision detected
                       break
                    end
                end
            end
        end
    end
    -- return true if the board is cleared
    if checkVictory(msg.bricks) then
        score_bonas(msg)
    end
    return msg.breakout
end