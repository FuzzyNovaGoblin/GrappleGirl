require("camera")
-- Initialize basic tiles, level editor doesn't need textures or anything fancy.
Tile = {
	{
		name = "air",
		color = {255, 255, 255},
		id = 0
	},
	{
		name = "wall",
		color = {0, 0, 0},
		id = 1
	},
	{
		name = "lava",
		color = {255, 0, 0},
		id = 2
	}
}
TileSize = 20

-- Create a map of all of the tiles by name
local byName = {}
-- Populate the map
for key, value in pairs(Tile) do
	byName[value.name] = value
end
Tile.byName = byName