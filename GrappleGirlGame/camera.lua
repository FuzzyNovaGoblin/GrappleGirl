

Camera = {}

function Camera:new(width, height, margin_left, margin_top, margin_right, margin_bottom)
   o = {}
   setmetatable(o, self)
   self.__index = self
   self.offset = {x = 0, y = 0}
   self.screenSize = {w = width or 0, h = height or 0}
   self.margins = {left = margin_left or 0.25, top = margin_top or 0.2, right = margin_right or margin_left or 0.25, bottom = margin_bottom or top or 0.2,}
   return o
end


function Camera:applyOffset(x, y)
   return x - self.offset.x, y - self.offset.y
end

function Camera:reverseOffset(x, y)
   return x + self.offset.x, y + self.offset.y
end

function Camera:update(player)
   local ogx, ogy = player.body:getPosition()
   local x, y = self:applyOffset(ogx, ogy)
   if x < self.screenSize.w * self.margins.left then
      self.offset.x = ogx - self.screenSize.w * self.margins.left
   end
   if x >  self.screenSize.w *(1- self.margins.right) then
      self.offset.x = ogx - self.screenSize.w + (self.screenSize.w * self.margins.right)
   end
   if y < self.screenSize.h * self.margins.top then
      self.offset.y = ogy - self.screenSize.h * self.margins.top
   end
   if y >  self.screenSize.h *(1- self.margins.bottom) then
      self.offset.y = ogy - self.screenSize.h + (self.screenSize.h * self.margins.bottom)
   end
end
