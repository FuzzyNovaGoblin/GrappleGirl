local class = require("class")
local vec2 = class:derive("Vector2")

function vec2:new(x,y)
    self.x = x or 0
    self.y = y or 0
end

return vec2