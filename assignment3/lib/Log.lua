-- log.lua
-- k.r.bergerstock
-- 2018.09.25

-- luacheck: allow_defined, no unused, globals  o Class love

if not rawget(getmetatable(o) or {},'__Class') then
	Class = require 'lib/class'
end

LOG = Class{}

function LOG:init(iden)
    self.fileName_ = ''
    self.Name = ''
    self.iden = iden
end

function LOG:initialize(fp)
    self.Name = fp or 'lualog'
    self.fileName_ = self.Name .. '.log'
    local line = self.Name .. '\n'
    love.filesystem.setIdentity(self.iden)
    love.filesystem.write(self.fileName_, line , #line )

end

function LOG:log(string)
    local line = string .. '\n'
    love.filesystem.append(self.fileName_, line, #line )
end