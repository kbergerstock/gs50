
-- luacheck: allow_defined, no unused
-- luacheck: globals Class love setColor readOnly BaseState
-- luacheck: globals gSounds gTextures gFrames gFonts

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

function update_score(msgs,brick)
    -- add to score
    -- ts == tier scale
    -- bs == brick color scale
    local s = 0
    if brick.keyBrick then
        s = math.max(1000,msgs.level * 125)
        msgs.breakout = true
    else
        s =  (brick.tier * 100 + brick.color * 5)
    end

    msgs.score = msgs.score + s

    -- trigger the brick's hit function, which removes it from play
    brick:hit()

    -- if we have enough points, recover a point of health
    if msgs.score > msgs.recoverPoints then
        -- can't go above 3 health
        msgs.health = math.min(3, msgs.health + 1)

        -- multiply recover points by 2
        msgs.recoverPoints = math.min(msg.recoverPoints + 10000, msgs.recoverPoints * 2)

        -- play recover sound effect
        gSounds['recover']:play()
    end
end

-- update scoring using different parameters if it is the keybrick
function handle_scoring(msgs, brick)
    if brick.keyBrick then
        if msgs.keyCaught then
            update_score(msgs, brick)
        end
    else
        update_score(msgs, brick)
    end
end

function score_bonas(msgs)
    msgs.score = msgs.score + msgs.level  * 500
end

function detect_and_handle_brick_collisions(msgs)
    -- process all active balls
    for i , ball in pairs(msgs.balls:getList()) do
         if ball:isActive()  then
            -- detect collision across all bricks with the ball
            for k, brick in pairs(msgs.bricks) do
                if brick.inPlay then
                    if ball:collides(brick) then
                        -- change the ball movement vectors
                        handle_brick_collision(ball, brick)
                        -- update scoring
                        handle_scoring(msgs,brick)
                        -- only allow colliding with one brick, for corners
                        -- break the loop on first collision detected
                       break
                    end
                end
            end
        end
    end
    -- return true if the board is cleared
    if checkVictory(msgs.bricks) then
        score_bonas(msgs)
    end
    return msgs.breakout
end