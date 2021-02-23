-- Initialize basic tiles, level editor doesn't need textures or anything fancy.
tiles = {
	{
		name = "air",
		color = {255, 255, 255}
	},
	{
		name = "wall",
		color = {0, 0, 0}
	},
	{
		name = "lava",
		color = {255, 0, 0}
	}
}

camera = {x = 0, y = 0}

-- Create a map of all of the tiles by name
tilesByName = {}
-- Populate the map
for key, value in pairs(tiles) do
	tilesByName[value.name] = value
end

love.window.setTitle("Level Editor")
local width, height = love.graphics.getDimensions()

-- Draw a single tile to the screen. Inverts y so that 0 is the bottom of the window.
function drawTile(tile, x, y)
	love.graphics.setColor(tile.color[1] / 255, tile.color[2] / 255, tile.color[3] / 255, 1)
	-- Account for camera position
	local xPos = (x * 20) + camera.x
	local yPos = (height - ((y + 1) * 20)) + camera.y
	love.graphics.rectangle("fill", xPos, yPos, 20, 20)
end

function love.update()
	-- Set default move speed
	local diff = 4
	-- If left shift is pressed, move faster
	if love.keyboard.isDown("lshift") then
		diff = 10
	end
	-- Handle WASD for camera movement
	if love.keyboard.isDown("w") then
		camera.y = camera.y + diff
	end
	if love.keyboard.isDown("s") then
		camera.y = camera.y - diff
	end
	if love.keyboard.isDown("a") then
		camera.x = camera.x + diff
	end
	if love.keyboard.isDown("d") then
		camera.x = camera.x - diff
	end
end

function love.draw()
	-- Test drawing single tile, TODO implement editing tiles
	drawTile(tilesByName.lava, 0, 0)
end
