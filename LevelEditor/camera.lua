Camera = {x = 0, y = 0}

-- Call periodically to allow camera panning, call in love.update
function Camera.update()
    -- Set default move speed
	local diff = 4
	-- If left shift is pressed, move faster
	if love.keyboard.isDown("lshift") then
		diff = 10
	end
	-- Handle WASD for camera movement
	if love.keyboard.isDown("w") then
		Camera.y = Camera.y + diff
	end
	if love.keyboard.isDown("s") then
		Camera.y = Camera.y - diff
	end
	if love.keyboard.isDown("a") then
		Camera.x = Camera.x + diff
	end
	if love.keyboard.isDown("d") then
		Camera.x = Camera.x - diff
	end
end