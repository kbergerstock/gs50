--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

-- luacheck: allow_defined, no unused
-- luacheck: globals  setColor love
-- luacheck: globals gFonts gTextures gFrames gSounds CONST BUSH_IDS
-- luacheck: globals Tile GameObject GameLevel TileMap



function GenerateLevel(width, height)
    -- converting from a two dimensional array to a single dimension
    -- this will improve rendering amd processing speed
    -- to access a tile should be (x-1) * height + y

    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = CONST.TILE_ID_GROUND

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)
    ----------------------------------------------------
    local function set(tile)
        -- stored by colums instead of rows
        -- position 1,1 == ndx 1
        -- position 2,2 == ndx 12
        local ndx = (tile.x - 1) * height + tile.y
        tiles[ndx]=tile
    end
    ----------------------------------------------------
    -- insert into object list a new bush
    local function createBush(tx)
        table.insert(objects,
            GameObject {
                texture = 'bushes',
                x = (tx - 1) * CONST.TILE_SIZE,
                y = (4 - 1) * CONST.TILE_SIZE,
                width = 16,
                height = 16,

                -- select random frame from bush_ids whitelist, then random row for variance
                frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
            }
        )
    end
    ----------------------------------------------------
    -- insert into object list a new jump block
    local function createJumpBlock(tx, blockHeight)
        table.insert(objects,
            -- jump block
            GameObject {
                texture = 'jump-blocks',
                x = (tx - 1) * CONST.TILE_SIZE,
                y = (blockHeight - 1) * CONST.TILE_SIZE,
                width = 16,
                height = 16,
                -- make it a random variant
                frame = math.random(#JUMP_BLOCKS),
                collidable = true,
                hit = false,
                solid = true,

                -- collision function takes itself
                onCollide = function(obj)

                    -- spawn a gem if we haven't already hit the block
                    if not obj.hit then

                        -- chance to spawn gem, not guaranteed
                        if math.random(5) == 1 then
                            -- this is run dynamically when a collision occurs with the jump block
                            -- maintain reference so we can set it to nil
                            local gem = GemObject {
                                texture = 'gems',
                                x = (tx - 1) * CONST.TILE_SIZE,
                                y =  (blockHeight -2) * CONST.TILE_SIZE,
                                width = 16,
                                height = 16,
                                frame = math.random(#GEMS),
                                collidable = true,
                                consumable = true,
                                solid = false,

                                -- gem has its own function to add to the player's score
                                onConsume = function(player, object)
                                    gSounds['pickup']:play()
                                    player.score = player.score + 100
                                end
                            }
                            -- FIX
                            -- make the gem move up from the block and play a sound
                            -- Timer.tween(0.1, {[gem] = {y = (blockHeight - 2) * CONST.TILE_SIZE}})
                            gem.y  = (blockHeight - 1) * CONST.TILE_SIZE - 4
                            width = 16,
                            gSounds['powerup-reveal']:play()
                            table.insert(objects, gem)
                        end

                        obj.hit = true
                    end

                    gSounds['empty-block']:play()
                end
            }
        )
    end
    ----------------------------------------------------
    -- generate tile map
     -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tile_id = CONST.TILE_ID_EMPTY

        -- lay out the empty space
        for y = 1, 6 do
            set(Tile(x, y, tile_id, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                set(Tile(x, y, tile_id, nil, tileset, topperset))
            end
        else
            tile_id = CONST.TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                set(Tile(x, y, tile_id, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2

                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    createBush(x)
                end

                -- pillar tiles
                set(Tile(x, 5, tileID, topper, tileset, topperset))
                set(Tile(x, 6, tileID, nil, tileset, topperset))
                -- tiles[1 + #tiles].topper = nil

            -- chance to generate bushes
            elseif math.random(8) == 1 then
                createBush(x)
            end

            -- chance to spawn a jump block
            if math.random(10) == 1 then
               createJumpBlock(x,blockHeight)
            end
        end
    end

    local map = TileMap(width, height,tiles)

    return GameLevel(entities, objects, map)
end
