-- read and parse a level file
-- k.r.bergerstock  @ 2019.02.02

-- luacheck: allow_defined, no unused
-- luacheck: globals o Class love readOnly Tile Wave aTile TileMap

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end
require 'lib/readonly'
require 'lib/log'
require 'src/Tile'
require 'src/TileMap'

Level = Class{}

function Level:init()
    self.background = 0
    self.map_width  = 0
    self.map_height = 0
    self.tile_size  = 0
    self.tiles = {}

    local ids = {
                --tile ids
                EMPTY    = 0,
                GROUND   = 1,
                TOPPER   = 2,
                BUSH     = 3,
                WATER    = 4,
                WAVE     = 5,
                GND7     = 6,
                GND8     = 7,
                GND9     = 8,
                JUMP_BLOCK = 9,
                LADDER = 10,
                LADDER_TOP = 11,
                SPRING = 12,
                SWITCH = 13,
                SIGN = 14,
                CRATE = 15,
    }
    ID = readOnly(ids)
end

function Level:get_pixel_width()
    return self.tile_size * self.map_width
end

function Level:get_pixel_height()
    return self.tile_size * self.map_height
end

function read_number(lines, string)
    local i,j
    i, j = string.find(lines,string)
    return tonumber(string.match(lines, "(%d+)",j+1))
end
-- ---------------------------------------------------------------
function read_array(lines, sb, se)
    local A = {}
    local i, j, k, l, m
    i, j = string.find(lines,sb)
    k, l = string.find(lines,se,j)
    m = string.sub(lines, j+1 , k-1)
    i = 1
    for n in string.gmatch(m,"(%d+)") do
        A[i] = tonumber(n)
        i = i + 1
    end
    return A
end-- ---------------------------------------------------------------
function read_search_table(lines, sb, se)
    local A = {}
    local i, j, k, l, m
    i, j = string.find(lines,sb)
    k, l = string.find(lines,se,j)
    m = string.sub(lines, j+1 , k-1)
    for n in string.gmatch(m,"(%d+)") do
        A[tonumber(n)] = true
    end
    return A
end
-- ---------------------------------------------------------------
function read_file(identity, file_name)
    local lines
    local size
    -- verify file esists
    love.filesystem.setIdentity(identity)
    lines , size = love.filesystem.read(file_name)
    if not lines and true then
        -- if lines is nil, size holds the error msg
        assert(lines,size)
    else
        return lines
    end
end
-- ---------------------------------------------------------------

function Level:load(lines)
    local def_gnd = {}
    local def = {}

    self.level = read_number(lines,'level:=')
    self.background = read_number(lines,'background:=')
    self.map_width = read_number(lines, 'map_tiles_wide:=')
    self.map_height = read_number(lines,'map_tiles_high:=')
    self.tile_size = read_number(lines,'tile_size:=')
    self.gravity = read_number(lines, 'gravity:=')
    self.pc_walk_speed = read_number(lines,'player_walk_speed:=')
    self.pc_jump_speed = read_number(lines, 'player_jump_speed:=')
    self.snail_speed = read_number(lines,'snail_move_speed:=')
    def_gnd.tile_set = read_number(lines,'tile_set:=')
    def_gnd.topper_set = read_number(lines,'topper_set:=')
    def.wave_set = read_number(lines,'wave_set:=')
    -- --------------------------------------------------
    local function Set(tile)
        -- tx and ty are zero based indices
        local idx = tile.ty * self.map_width + tile.tx + 1
        self.tiles[idx] = tile
    end
    -- --------------------------------------------------
    function list_iter (t)
        local i = 0
        local n = #t
        return function ()
                    i = i + 1
                    if i <= n then return t[i] else return 1 end
                end
        end
    -- --------------------------------------------------
    -- read the tile mappings in
    -- tile mpppings are a look up table of indices that represent the tile  we want to display
    -- so instead of looking up tile_set[tile_id] we look up tile_set[tile_mapping[tile_id]]
    -- this way we can use different tile sets without changing the map
    local tile_mapping =  read_array(lines,'tile_mappings:={','}end')

    -- read the bush mappings in
    local bush_set = read_number(lines,'bush_set:=')
    local bushes = list_iter(read_array(lines,'bushes:={','}end') )
    -- read the jump_blocks mappings in
    local jump_blocks = list_iter(read_array(lines,'jump_blocks:={','}end') )
    -- read the crate mappings in
    local crates = list_iter(read_array(lines,'crates:={','}end') )
    -- reads the ladder  set in
    local ladder =  read_number(lines,'ladder:=')
    local ladder_top = read_number(lines,'ladder_top:=')

    -- read in the tile id's for the map
    local ids  = read_array(lines,'map:begin','map:end')
    -- list of ids that an entity can pass in front of
    self.transparent_ids = read_search_table(lines,'transparent_ids:=','}end')
    -- list of ids than an entity will collide with
    self.collide_ids = read_search_table(lines,'collide_ids:=','}end')

    def.tile_size = self.tile_size
    def_gnd.tile_size = self.tile_size
    def_gnd.tile_set_width = read_number(lines,'tile_set_width:=')
    def_gnd.tile_set_height = read_number(lines,'tile_set_height:=')
    def_gnd.tile_sets_wide = read_number(lines,'tile_sets_wide:=')
    def_gnd.tile_sets_tall = read_number(lines,'tile_sets_tall:=')

    local tx = 0
    local ty = 0
    for n,id in pairs(ids) do
        def.id = id
        def.tx = tx
        def.ty = ty
        if (id == ID.WATER) or (id == ID.WAVE) then
            def.sdx = tile_mapping[id + 1]
            Set(Wave(def))
        elseif id == ID.BUSH then
            def.tile_set = 'bushes'
            def.sdx = (bush_set - 1) * 7 + bushes()
            Set(aTile(def))
        elseif id == ID.JUMP_BLOCK  then
            def.tile_set = 'jump-blocks'
            def.sdx = jump_blocks()
            Set(aTile(def))
        elseif id == ID.CRATE then
            def.tile_set = 'crates'
            def.sdx = crates()
            Set(aTile(def))
        elseif id == ID.LADDER then
            def.tile_set = 'ladders'
            def.sdx = ladder
            Set(aTile(def))
        elseif id == ID.LADDER_TOP then
            def.tile_set = 'ladders'
            def.sdx = ladder_top
            Set(aTile(def))
        else
            def_gnd.id = id
            def_gnd.sdx = tile_mapping[id + 1]
            def_gnd.tx = tx
            def_gnd.ty = ty
            Set(Tile(def_gnd))
        end
        ty = ty + 1
        if ty >= self.map_height then
            ty = 0
            tx = tx + 1
            if tx >= self.map_width then
                break
            end
        end
    end
    return TileMap(self)
end