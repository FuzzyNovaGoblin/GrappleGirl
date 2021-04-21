local class = require("class")
local Block = class:derive("Block")


function Block:new(x, y, w, h)
   self.pos = {x = x or 0, y = y or 0}
   self.size = {w = w or 0, h = h or 0}
   self.color = nil

   self.shape = love.physics.newRectangleShape(self.size.w, self.size.h)
   self.body = love.physics.newBody(baseWorld, self.pos.x, self.pos.y, "kinematic")
   self.fixture = love.physics.newFixture(self.body, self.shape, 1)
   self.fixture:setFriction(1)
   self.fixture:setCategory(BLOCK_CATEGORY)
end

function Block:draw()
   local dPos = {}
   dPos.x = self.body:getPosition()
   dPos.y = self.pos.y
   dPos.x, dPos.y = Camera:applyOffset(dPos.x, dPos.y)
   love.graphics.rectangle("fill", dPos.x - (self.size.w / 2), dPos.y - (self.size.h / 2), self.size.w, self.size.h)
end

return Block