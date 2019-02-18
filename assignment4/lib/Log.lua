-- log.lua
-- k.r.bergerstock
-- 2018.09.25

-- luacheck: allow_defined, no unused, globals  o Class love

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

LOG = Class{}

function LOG:init(iden)
    self.fileName = ''
    self.iden = iden
end

function LOG:initialize(fp)
    local name = (fp and true) or 'lualog'
    self.fileName = name .. '.log'
    local line = 'LOG: ' .. name .. '\n'
    love.filesystem.setIdentity(self.iden)
    love.filesystem.write(self.fileName, line , #line )

end

function LOG:wrt(line)
    assert(line,'grr this cannot be')
    line = line .. '\n'
    love.filesystem.append(self.fileName, line, #line )
end