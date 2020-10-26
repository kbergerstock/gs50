
-- K.R.Bergerstock 09/2018, 01/2019
-- store constants in a read only table

require 'lib/readonly'

-- luacheck: allow_defined, no unused, globals readOnly read_number
-- luacheck: ignore loadConstants

function loadConstants(lines)
    local p = {
        -- size of our actual window
        WINDOW_WIDTH = read_number(lines, 'window_width:='),
        WINDOW_HEIGHT = read_number(lines, 'window_height:='),

        -- size we're trying to emulate with push
        VIRTUAL_WIDTH = read_number(lines, 'virtual_width:='),
        VIRTUAL_HEIGHT = read_number(lines, 'virtual_height:='),

        -- camera scrolling speed
        CAMERA_SPEED = read_number(lines, 'camera_speed:='),

        -- speed of scrolling background
        -- BACKGROUND_SCROLL_SPEED = (),

        -- standard tile size
        TILE_SIZE = read_number(lines, 'tile_size:='),

        -- number of tiles in each tile set
        TILE_SET_WIDTH  = read_number(lines, 'tile_set_width:='),
        TILE_SET_HEIGHT = read_number(lines, 'tile_set_height:='),

        -- number of tile sets in sheet
        TILE_SETS_WIDE = read_number(lines, 'tile_sets_wide:='),
        TILE_SETS_TALL = read_number(lines, 'tile_sets_tall:='),

        -- number of topper sets in sheet
        TOPPER_SETS_WIDE = read_number(lines, 'topper_sets_wide:='),
        TOPPER_SETS_TALL = read_number(lines, 'topper_sets_tall:='),
    }

    -- width and height of screen in tiles
    p.SCREEN_TILE_WIDTH = p.VIRTUAL_WIDTH / p.TILE_SIZE
    p.SCREEN_TILE_HEIGHT = p.VIRTUAL_HEIGHT / p.TILE_SIZE

    return p
end