--[[
    GD50
    Breakout Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Creates randomized levels for our Breakout game. Returns a table of
    bricks that the game can render, based on the current level we're at
    in the game.

    lua 5.3 did not like the goto I fixed the logic and elimninated it KRB
]]

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

LevelMaker = Class{}

--[[
    Creates a table of Bricks to be returned to the main game, with different
    possible ways of randomizing rows and columns of bricks. Calculates the
    brick colors and tiers to choose based on the level passed in.
]]
function LevelMaker.createMap(level)
    local bricks = {}
    local keyBrickFlag = true
    local k = false 
    -- randomly choose the number of rows
    local numRows = math.random(1, 5)
    local kbRow =  numRows > 2 and 2 or 1

    -- randomly choose the number of columns, ensuring odd
    local numCols = math.random(7, 13)
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols
    local kbCol = 1 + math.floor(numCols / 2 )
        
    -- highest possible spawned brick color in this level; ensure we
    -- don't go above 3
    local highestTier = math.min(3, math.floor(level / 5))

    -- highest color of the highest tier, no higher than 5
    local highestColor = math.min(5, level % 5 + 3)

    -- lay out bricks such that they touch each other and fill the space
    for y = 1, numRows do
        -- whether we want to enable skipping for this row
        local skipPattern = math.random(1, 2) == 1 

        -- whether we want to enable alternating colors for this row
        local alternatePattern = math.random(1, 2) == 1 
        
        -- choose two colors to alternate between
        local alternateColor1 = math.random(1, highestColor)
        local alternateColor2 = math.random(1, highestColor)
        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier)
        
        -- used only when we want to skip a block, for skip pattern
        local skipFlag = math.random(2) == 1 

        -- used only when we want to alternate a block, for alternate pattern
        local alternateFlag = math.random(2) == 1 

        -- solid color we'll use if we're not skipping or alternating
        local solidColor = math.random(1, highestColor)
        local solidTier = math.random(0, highestTier)

        for x = 1, numCols do
            -- if skipping is turned on 
            -- flip the skip flag
            -- otherwise set the skp flag to false
            -- so that the next conditional performs it's job
            if skipPattern  then
                skipFlag = not skipFlag
            else
                skipFlag = false
            end

            if keyBrickFlag and y == kbRow and x == kbCol then 
                k = true              
              else
                k = false
            end

            -- if the skip flag is not on then add a brick
            if k or not skipFlag then
                b = Brick(
                    -- x-coordinate
                    (x-1)                   -- decrement x by 1 because tables are 1-indexed, coords are 0
                    * 32                    -- multiply by 32, the brick width
                    + 8                     -- the screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
                    + (13 - numCols) * 16,  -- left-side padding for when there are fewer than 13 columns
                    
                    -- y-coordinate
                    y * 16,                 -- just use y * 16, since we need top padding anyway
                    k                       -- the keybrick flag
                )
                if not k then
                -- if we're alternating, figure out which color/tier we're on
                    if alternatePattern then
                        if alternateFlag then
                            b.color = alternateColor1
                            b.tier = alternateTier1
                        else
                            b.color = alternateColor2
                            b.tier = alternateTier2
                        end
                        alternateFlag = not alternateFlag
                    else
                        -- if not alternating and we made it here, use the solid color/tier
                        b.color = solidColor
                        b.tier = solidTier
                    end
                end 

                table.insert(bricks, b)
            end
        end
    end 

    -- in the event we didn't generate any bricks, try again
    -- return a nil indicating am error to the calling level
    -- fix there should some way to exit with an error msg here
    -- fix it is possible (unlikely, but i have seen the impossible happen)
    -- fix that this condinitional statement could wind up in an endless loop
    -- ie never-never land and random number gernerators have been known to fail
    if #bricks == 0 then
        return nil
    else
        return bricks, keyBrickFlag
    end
end