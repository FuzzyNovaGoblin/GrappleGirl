weapon = {}

WEAPONS = {
  grapplegun = {
    name = "grapplegun", -- Weapon name
    damage = 0, -- Weapon Damage
    img = grapplegun -- Put Sprite here
  },
  bullet = {
    img = bullet
  }
}

-- Raycast method to see if it hits wall/enemy

-- Inserts bullets into table when called
function weapon:shoot(x, y, angle)
  local dx, dy = bullets.bulletSpeed * math.cos(angle), bullets.bulletSpeed * math.sin(angle)
  table.insert(bullets, {x = x, y = y, dx = dx, dy = dy})
end

-- Rotateupdate updates the rotation of the gun
function weapon:rotateUpdate(x, y, angle)
  love.graphics.draw(WEAPONS.grapplegun.img, x, y, angle, .5, .5, 3, 13)

  -- love.graphics.setColor(255, 0, 0, 1)
end
-- Spawns bullets and draws to screen
function weapon:spawnBullets(angle)
  love.graphics.setColor(1, 0, 0)
  for i,v in ipairs(bullets) do
    love.graphics.draw(WEAPONS.bullet.img, v.x, v.y, angle, .01, .01, 0, 13)
  end
end

--[[Draws rectagle for debug testing]]--
function weapon:draw()
  love.graphics.rectangle('fill', 20, 20, 20, 20)
  love.graphics.setColor(255, 255, 255, 1)
end
