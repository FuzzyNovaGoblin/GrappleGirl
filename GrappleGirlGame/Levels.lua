require("config")
local Block = require("block")

Level = {}

function Level:loadLevel(filename)
   Level.blocks = {}

   loadfile(filename)()
   for y = 1, level.height do
      for x = 1, level.width do
         if level[x][y] == 2 then
            table.insert(Level.blocks, Block( x * BLOCK_WIDTH, -y * BLOCK_HEIGHT, BLOCK_WIDTH, BLOCK_HEIGHT))

         end
      end
   end

   gGirl.body:setX(level.spawn.x*BLOCK_WIDTH)
   gGirl.body:setY(-level.spawn.y*BLOCK_HEIGHT)

end
