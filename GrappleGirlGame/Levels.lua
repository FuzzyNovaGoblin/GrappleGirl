require("config")

Level = {}

function Level:loadLevel(filename)
   local o = {}
   setmetatable(o, self)
   self.blocks = {}

   loadfile(filename)()
   -- for y = 1, level.height do
   --    for x = 1, level.width do
   --       table.insert(self.blocks, Block:new(x * BLOCK_HEIGHT, y * BLOCK_WIDTH, BLOCK_HEIGHT, BLOCK_WIDTH))
   --    end
   -- end

   table.insert(self.blocks, Block:new(400 , 260 , 60,50))
   self.__index = self
   return o
end

Block = {}

function Block:new(x, y, w, h)
   o = {}
   setmetatable(o, self)
   self.__index = self
   self.pos = {x = x or 0, y = y or 0}
   self.size = {w = w or 0, h = h or 0}
   self.color = nil


   self.shape = love.physics.newRectangleShape(self.size.w, self.size.h)
   self.body = love.physics.newBody(baseWorld, self.pos.x, self.pos.y, "kinematic")
   self.fixture = love.physics.newFixture(self.body, self.shape, 1)
   self.fixture:setFriction(1)
   self.fixture:setCategory(BLOCK_CATEGORY)


   return o
end

function Block:draw()
   local dPos = {}
    dPos.x, dPos.y = self.body:getPosition()
    dPos.x, dPos.y = Camera:applyOffset(dPos.x, dPos.y)
   love.graphics.rectangle("fill", dPos.x, dPos.x, self.size.w, self.size.h)
end
