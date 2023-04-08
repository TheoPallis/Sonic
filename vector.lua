-- vector.lua
local vector = {}
vector.__index = vector

function vector.new(x, y)
    return setmetatable({x = x or 0, y = y or 0}, vector)
end

function vector:normalized()
    local len = self:len()
    return vector.new(self.x / len, self.y / len)
end

function vector:len()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

return setmetatable(vector, {__call = function(_, x, y) return vector.new(x, y) end})
