Combat = {}

WEAPONS = {
  {
    name = "grapplegun", -- Weapon name
    damage = 0, -- Weapon Damage
    img = {grapplegun} -- Put Sprite here
  }
}

-- Fire
function Combat:attack(x, y)
  love.graphics.setColor(0, 255, 0, 1)
  love.graphics.circle("fill", x, y, 5)

end

-- Spawn
function Combat:update(x, y, angle)
  -- love.graphics.circle("fill", x, y, 5)
   love.graphics.draw(grapplegun, x, y, angle, .75, .75, 10, 10)
  love.graphics.setColor(255, 0, 0, 1)
end

--[[Draws rectagle for debug testing]]--
function Combat:new()
  love.graphics.rectangle('fill', 20, 20, 20, 20)
  love.graphics.setColor(255, 255, 255, 1)
end
