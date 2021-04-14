local class = require("class")
local Sprite = class:derive("Sprite")


function Sprite:new()
    self.animations = {}
end

function Sprite:animate(anim)
end

function Sprite:update(dt)
end

function Sprite:draw()
end

return Sprite




