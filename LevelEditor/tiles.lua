require("camera")
-- Initialize basic tiles, level editor doesn't need textures or anything fancy.
Tile = {
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

local width, height = love.graphics.getDimensions()
TileSize = 20

-- Create a map of all of the tiles by name
local byName = {}
-- Populate the map
for key, value in pairs(Tile) do
	byName[value.name] = value
end
Tile.byName = byName

-- Draw a single tile to the screen. Inverts y so that 0 is the bottom of the window.
function Tile.drawTile(tile, x, y)
	love.graphics.setColor(tile.color[1] / 255, tile.color[2] / 255, tile.color[3] / 255, 1)
	-- Account for camera position
	local xPos = (x * TileSize) + Camera.x
	local yPos = (height - ((y + 1) * TileSize)) + Camera.y
	love.graphics.rectangle("fill", xPos, yPos, TileSize, TileSize)
end