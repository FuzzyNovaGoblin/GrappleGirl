require("config")

Level = {}

function Level:loadLevel(filename)
   Level.blocks = {}

   loadfile(filename)()
   for y = 1, level.height do
      for x = 1, level.width do
         if level[x][y] == 2 then
            table.insert(Level.blocks, {})
            Block:new(Level.blocks[#Level.blocks], x * BLOCK_WIDTH, -y * BLOCK_HEIGHT, BLOCK_WIDTH, BLOCK_HEIGHT)
         end
      end
   end

   gGirl.body:setX(level.spawn.x*BLOCK_WIDTH)
   gGirl.body:setY(-level.spawn.y*BLOCK_HEIGHT)
   gGirl.body:setX(100)
   gGirl.body:setY(-100)

end

Block = {}

function Block:new(b, x, y, w, h)

   b.__index = b

   b.pos = {x = x or 0, y = y or 0}
   b.size = {w = w or 0, h = h or 0}
   b.color = nil

   b.shape = love.physics.newRectangleShape(b.size.w, b.size.h)
   b.body = love.physics.newBody(baseWorld, b.pos.x, b.pos.y, "kinematic")
   b.fixture = love.physics.newFixture(b.body, b.shape, 1)
   b.fixture:setFriction(1)
   b.fixture:setCategory(BLOCK_CATEGORY)

   return b
end

function Block:draw(b)
   local dPos = {}
   dPos.x = b.body:getPosition()
   dPos.y = b.pos.y
   dPos.x, dPos.y = Camera:applyOffset(dPos.x, dPos.y)
   love.graphics.rectangle("fill", dPos.x - (b.size.w / 2), dPos.y - (b.size.h / 2), b.size.w, b.size.h)
end
