local class = require("class")
local Block = class:derive("Block")

function Block:new(typecode, x, y, w, h)
   self.typecode = typecode
   self.pos = {x = x or 0, y = y or 0}
   self.size = {w = w or 0, h = h or 0}
   self.color = {1,1,1}

   if (self.typecode == 2) then
      self.color = {1, 1, 1}
   elseif (self.typecode == 3) then
      self.color = {1, .1, .1}
   end

   self.shape = love.physics.newRectangleShape(self.size.w, self.size.h)
   self.body = love.physics.newBody(baseWorld, self.pos.x, self.pos.y, "kinematic")
   self.fixture = love.physics.newFixture(self.body, self.shape, 1)
   self.fixture:setFriction(1)
   
   if (typecode == 2) then
      self.fixture:setCategory(BLOCK_CATEGORY)
   elseif (typecode == 3) then
      self.fixture:setCategory(LAVA_CATEGORY)
   end
end

function Block:draw()
   local dPos = {}
   dPos.x = self.body:getPosition()
   dPos.y = self.pos.y
   dPos.x, dPos.y = Camera:applyOffset(dPos.x, dPos.y)


   love.graphics.setColor(self.color)
   love.graphics.rectangle("fill", dPos.x - (self.size.w / 2), dPos.y - (self.size.h / 2), self.size.w, self.size.h)
   love.graphics.setColor(1,1,1)

end

return Block
